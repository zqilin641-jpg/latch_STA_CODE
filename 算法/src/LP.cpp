#include <glpk.h>
#include <cstdio>
#include <iostream>

#include "LP.hpp"
#include "lp_result.hpp"

nanoseconds mcrLP(const string &fileName, double &tlp,
                  const LatchTimingParams &params,
                  const LatchTimingParamMap &nodeParams,
                  double dutyCycle,
                  vector<TimingConstraintSlack> *slacks,
                  McrLpResult *result)
{
    McrLpResult localResult;
    if (result == nullptr) result = &localResult;
    *result = McrLpResult{};
    tlp = std::numeric_limits<double>::quiet_NaN();
    if (slacks != nullptr) slacks->clear();
    auto change = high_resolution_clock::now() - high_resolution_clock::now();
    DelayGraph dg;
    double tInitial = 0;
    string fe = extension(fileName);
    const bool parsed = fe == "out" ? getDelayGraph(fileName, dg, tInitial) :
                        fe == "rslt" ? getRsltDelayGraph(fileName, dg, tInitial) : false;
    if (!parsed || boost::num_vertices(dg) == 0) {
        result->status = LpStatus::InputError;
        return nanoseconds(0);
    }
    //cout << "delay graph:" << endl;
    //cout << "#vertices = " << num_vertices(dg) << ", #edges = " << num_edges(dg) << endl;
    auto _v = boost::num_vertices(dg);
    auto _c = boost::num_edges(dg);
    int numvar = 4 * _v + 1;
    int numcon = 8 * _v + 2 * _c;
    int numcof = 15 * _v + 6 * _c; // number of non-zero coefficients
    boost::graph_traits<DelayGraph>::edge_iterator eibegin, eiend;

    glp_prob *lp;
    int *ia = new int[1 + numcof];
    int *ja = new int[1 + numcof]; //start from 1
    double *ar = new double[1 + numcof];
    lp = glp_create_prob();
    glp_set_prob_name(lp, "timing");
    glp_set_obj_dir(lp, GLP_MIN);
    glp_add_rows(lp, numcon);
    glp_add_cols(lp, numvar);
    glp_set_col_bnds(lp, 1, GLP_LO, 0.0, 0.0);
    for (int i = 2; i <= numvar; i++)
    {
        //glp_set_col_name(lp, i);
        glp_set_col_bnds(lp, i, GLP_FR, 0.0, 0.0);
    }
    int row = 1; //rth constraint
    int cn = 1;  //the index of subi/subj
    vector<TimingConstraintSlack> rowInfo(numcon + 1);
    auto describeRow = [&](int rowIndex, const string &source,
                           const string &target, const string &type) {
        rowInfo[rowIndex] = {source, target, type, 0.0};
    };

    for (size_t node = 0; node < _v; ++node)
    {
        auto vertex = boost::vertex(node, dg);
        int i = 4 * dg[vertex].idx + 2;
        const auto &timing = resolveLatchTimingParams(
            dg[vertex].name, params, nodeParams);
        const string &name = dg[vertex].name;

        describeRow(row, name, name, "hold");
        ia[cn] = row; ja[cn] = i; ar[cn++] = -1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, -timing.hold);

        describeRow(row, name, name, "setup");
        ia[cn] = row; ja[cn] = 1; ar[cn++] = -1.;
        ia[cn] = row; ja[cn] = i + 1; ar[cn++] = 1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, -timing.setup);

        describeRow(row, name, name, "earliest_data_to_q");
        ia[cn] = row; ja[cn] = i; ar[cn++] = 1.;
        ia[cn] = row; ja[cn] = i + 2; ar[cn++] = -1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, -timing.dataToQ);

        describeRow(row, name, name, "earliest_clock_to_q");
        ia[cn] = row; ja[cn] = 1; ar[cn++] = 1.0 - dutyCycle;
        ia[cn] = row; ja[cn] = i + 2; ar[cn++] = -1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, -timing.clockToQ);

        describeRow(row, name, name, "latest_data_to_q");
        ia[cn] = row; ja[cn] = i + 1; ar[cn++] = 1.;
        ia[cn] = row; ja[cn] = i + 3; ar[cn++] = -1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, -timing.dataToQ);

        describeRow(row, name, name, "latest_clock_to_q");
        ia[cn] = row; ja[cn] = 1; ar[cn++] = 1.0 - dutyCycle;
        ia[cn] = row; ja[cn] = i + 3; ar[cn++] = -1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, -timing.clockToQ);

        describeRow(row, name, name, "arrival_order");
        ia[cn] = row; ja[cn] = i; ar[cn++] = 1.;
        ia[cn] = row; ja[cn] = i + 1; ar[cn++] = -1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, 0.0);

        describeRow(row, name, name, "departure_order");
        ia[cn] = row; ja[cn] = i + 2; ar[cn++] = 1.;
        ia[cn] = row; ja[cn] = i + 3; ar[cn++] = -1.;
        glp_set_row_bnds(lp, row++, GLP_UP, 0.0, 0.0);
    }

    for (tie(eibegin, eiend) = boost::edges(dg); eibegin != eiend && cn <= numcof && row <= numcon; ++eibegin)
    {
        auto sourceVertex = boost::source(*eibegin, dg);
        auto targetVertex = boost::target(*eibegin, dg);
        int i = 4 * dg[sourceVertex].idx + 2;
        int j = 4 * dg[targetVertex].idx + 2;
        double Dmin = dg[*eibegin].minDelay;
        double Dmax = dg[*eibegin].maxDelay;
        //T+af-di<=Dmin
        describeRow(row, dg[sourceVertex].name, dg[targetVertex].name,
                    "min_path_hold");
        ia[cn] = row;
        ja[cn] = 1;
        ar[cn++] = 1.;
        ia[cn] = row;
        ja[cn] = j;
        ar[cn++] = 1.;
        ia[cn] = row;
        ja[cn] = i + 2;
        ar[cn++] = -1.;
        glp_set_row_bnds(lp, row, GLP_UP, 0.0, Dmin);
        ++row;
        //-T+Di-Af<=-Dmax
        describeRow(row, dg[sourceVertex].name, dg[targetVertex].name,
                    "max_path_setup");
        ia[cn] = row;
        ja[cn] = 1;
        ar[cn++] = -1.;
        ia[cn] = row;
        ja[cn] = i + 3;
        ar[cn++] = 1.;
        ia[cn] = row;
        ja[cn] = j + 1;
        ar[cn++] = -1.;
        glp_set_row_bnds(lp, row, GLP_UP, 0.0, -Dmax);
        ++row;
    }
    assert(row == numcon + 1 && cn == numcof + 1);
    glp_set_obj_coef(lp, 1, 1.0);
    // for(int i=1;i<numcof;i++)
    // 	cout<<ia[i]<<" "<<ja[i]<<" "<<ar[i]<<endl;
    glp_load_matrix(lp, numcof, ia, ja, ar);
    auto beginTime = high_resolution_clock::now();
    result->returnCode = glp_simplex(lp, NULL);
    result->solutionStatus = glp_get_status(lp);
    auto endTime = high_resolution_clock::now();
    change = endTime - beginTime + change;

    const double objective = result->returnCode == 0 && result->solutionStatus == GLP_OPT ?
                             glp_get_obj_val(lp) : std::numeric_limits<double>::quiet_NaN();
    *result = classifyMcrLpResult(result->returnCode, result->solutionStatus, objective);
    if (result->status == LpStatus::Optimal) tlp = objective;
    if (slacks != nullptr && result->status == LpStatus::Optimal)
    {
        slacks->clear();
        slacks->reserve(numcon);
        for (int rowIndex = 1; rowIndex <= numcon; ++rowIndex)
        {
            auto info = rowInfo[rowIndex];
            info.slack = glp_get_row_ub(lp, rowIndex) -
                         glp_get_row_prim(lp, rowIndex);
            slacks->push_back(info);
        }
    }
    // cout << "z=" << z << endl;
    glp_delete_prob(lp);
    delete[] ar;
    delete[] ia;
    delete[] ja;
    return duration_cast<nanoseconds>(change);
}
nanoseconds ellLP(const string &fileName, double &tlp, double &wlp)
{
    auto change = high_resolution_clock::now() - high_resolution_clock::now();
    DelayGraph dg;
    double tInitial = 0;
    string fe = extension(fileName);
    if (fe == "out")
        assert(getDelayGraph(fileName, dg, tInitial));
    else if (fe == "rslt")
        assert(getRsltDelayGraph(fileName, dg, tInitial));
    auto _v = boost::num_vertices(dg);
    auto _c = boost::num_edges(dg);
    int numvar = _v + 2;
    int numcon = 3 * _c;
    int numcof = 0; //nums of cof
    boost::graph_traits<DelayGraph>::edge_iterator eibegin, eiend;
    for (tie(eibegin, eiend) = boost::edges(dg); eibegin != eiend; ++eibegin)
    {
        if (boost::source(*eibegin, dg) == boost::target(*eibegin, dg))
            numcof += 4;
        else
            numcof += 10;
    }

    glp_prob *lp;
    int *ia = new int[1 + numcof];
    int *ja = new int[1 + numcof]; //start from 1
    double *ar = new double[1 + numcof];
    double z;
    lp = glp_create_prob();
    glp_set_prob_name(lp, "timing");
    glp_set_obj_dir(lp, GLP_MIN);
    glp_add_rows(lp, numcon);
    glp_add_cols(lp, numvar);
    glp_set_col_bnds(lp, 1, GLP_LO, 0.0, 0.0);
    glp_set_col_bnds(lp, 2, GLP_LO, 0.0, 0.0);
    for (int i = 3; i <= numvar; i++)
    {
        //glp_set_col_name(lp, i);
        glp_set_col_bnds(lp, i, GLP_FR, 0.0, 0.0);
    }
    int row = 1; //rth constraint
    int cn = 1;  //the index of subi/subj

    for (tie(eibegin, eiend) = boost::edges(dg); eibegin != eiend && cn <= numcof && row <= numcon; ++eibegin)
    {
        int i = boost::source(*eibegin, dg) + 3;
        int j = boost::target(*eibegin, dg) + 3;
        double Dmin = dg[*eibegin].minDelay;
        double Dmax = dg[*eibegin].maxDelay;
        if (i == j)
        {
            //-T<=-Dmax
            ia[cn] = row;
            ja[cn] = 1;
            ar[cn++] = -1.;
            glp_set_row_bnds(lp, row, GLP_UP, 0.0, -Dmax);
            ++row;
            //-T-W<=-Dmax
            ia[cn] = row;
            ja[cn] = 1;
            ar[cn++] = -1.;
            ia[cn] = row;
            ja[cn] = 2;
            ar[cn++] = -1.;
            glp_set_row_bnds(lp, row, GLP_UP, 0.0, -Dmax);
            ++row;
            //W<=Dmin
            ia[cn] = row;
            ja[cn] = 2;
            ar[cn++] = 1.;
            glp_set_row_bnds(lp, row, GLP_UP, 0.0, Dmin);
            ++row;
        }
        else
        {
            //-T+ti-tj<=-Dmax
            ia[cn] = row;
            ja[cn] = 1;
            ar[cn++] = -1.;
            ia[cn] = row;
            ja[cn] = i;
            ar[cn++] = 1.;
            ia[cn] = row;
            ja[cn] = j;
            ar[cn++] = -1.;
            glp_set_row_bnds(lp, row, GLP_UP, 0.0, -Dmax);
            ++row;
            //-T-W+ti-tj<=-Dmax
            ia[cn] = row;
            ja[cn] = 1;
            ar[cn++] = -1.;
            ia[cn] = row;
            ja[cn] = 2;
            ar[cn++] = -1.;
            ia[cn] = row;
            ja[cn] = i;
            ar[cn++] = 1.;
            ia[cn] = row;
            ja[cn] = j;
            ar[cn++] = -1.;
            glp_set_row_bnds(lp, row, GLP_UP, 0.0, -Dmax);
            ++row;
            //W-ti+tj<=Dmin
            ia[cn] = row;
            ja[cn] = 2;
            ar[cn++] = 1.;
            ia[cn] = row;
            ja[cn] = i;
            ar[cn++] = -1.;
            ia[cn] = row;
            ja[cn] = j;
            ar[cn++] = 1.;
            glp_set_row_bnds(lp, row, GLP_UP, 0.0, Dmin);
            ++row;
        }
    }
    glp_set_obj_coef(lp, 1, 1.0);
    glp_set_obj_coef(lp, 2, 1.0);
    // for(int i=1;i<numcof;i++)
    // 	cout<<ia[i]<<" "<<ja[i]<<" "<<ar[i]<<endl;
    glp_load_matrix(lp, numcof, ia, ja, ar);
    auto beginTime = high_resolution_clock::now();
    glp_simplex(lp, NULL);
    auto endTime = high_resolution_clock::now();
    change = endTime - beginTime + change;

    z = glp_get_obj_val(lp);
    tlp = glp_get_col_prim(lp, 1);
    wlp = glp_get_col_prim(lp, 2);

    glp_delete_prob(lp);
    delete[] ar;
    delete[] ia;
    delete[] ja;
    return duration_cast<nanoseconds>(change);
}

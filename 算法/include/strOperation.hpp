#pragma once

#include <string>
#include <vector>
#include <iostream>
#include <cmath>
#include <cstdlib>

using namespace std;

/**
 * @brief Test if a string is numeric. 
 * 
 * @param str 
 * @return true 
 * @return false 
 */
inline bool isNumeric(const string &str)
{
    for (size_t i = 0; i < str.size(); ++i)
    {
        if (!isdigit(str[i]) && str[i] != '.')
            return false;
    }
    return true;
}

/**
 * @brief Test if the character c is in the string str.
 * 
 * @param c 
 * @param str 
 * @return true 
 * @return false 
 */
inline bool isCharIn(char c, string str)
{
    for (size_t i = 0; i < str.size(); ++i)
        if (c == str[i])
            return true;
    return false;
}

/**
 * @brief Split a text line into seperate words, and store them in a vector of string.
 * 
 * @param str 
 * @param seps 
 * @param words 
 */
inline void splitString(const string &str, const string &seps, vector<string> &words)
{
    words.clear();
    size_t i = 0;
    while (isCharIn(str[i], seps))
        ++i;
    size_t beginIndex;
    bool isSepBefore = false;
    for (beginIndex = i; i != str.size(); ++i)
    {
        if (isCharIn(str[i], seps))
        {
            if (!isSepBefore)
            {
                words.push_back(str.substr(beginIndex, i - beginIndex));
                beginIndex = i + 1;
                isSepBefore = true;
            }
            else
                beginIndex = i + 1;
        }
        else
            isSepBefore = false;
    }
    if (!str.empty() && !isSepBefore)
        words.push_back(str.substr(beginIndex, i - beginIndex));
}

/**
 * @brief Get file extension
 * 
 * @param filename 
 * @return string 
 */
inline string extension(const string &filename){
    vector<string> words;
    splitString(filename, ".", words);
    return words.back();
}
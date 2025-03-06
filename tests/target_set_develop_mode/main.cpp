/* SPDX-License-Identifier: MIT */
/* SPDX-FileCopyrightText: Copyright (c) 2025 JanSimplify */

#include <iostream>

static void switch_case()
{
    enum E
    {
        A,
        B
    };
    E a = A;
    switch (a)
    {
    case A:
        break;

    default:
        break;
    }
}

int main()
{
    switch_case();
    return 0;
}

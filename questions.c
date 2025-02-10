/*
 * Tutorial 4 Jeopardy Project for SOFE 3950U / CSCI 3020U: Operating Systems
 *
 * Copyright (C) 2015, <GROUP MEMBERS>
 * All rights reserved.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "questions.h"

// Categories for the quiz game
char categories[NUM_CATEGORIES][MAX_LEN] = {
    "programming",
    "algorithms",
    "databases"};

// Array to store quiz questions
question questions[NUM_QUESTIONS];

// Initializes the question bank
void initialize_game(void)
{
    question temp_questions[NUM_QUESTIONS] = {
        {"programming", "What is the file extension for a Python source code file?", ".py", 100, false},
        {"algorithms", "What data structure follows the First In, First Out (FIFO) principle?", "queue", 100, false},
        {"databases", "What type of database model stores data in tables with rows and columns?", "relational", 100, false},
        {"programming", "Which programming language is known for its use in developing Android applications?", "java", 200, false},
        {"algorithms", "In algorithmic analysis, what does O(n) represent?", "linear", 200, false},
        {"databases", "In a relational database, what represents a single data value in a record?", "attribute", 200, false},
        {"programming", "What is the purpose of the printf function in C?", "print", 300, false},
        {"algorithms", "In algorithmic complexity, what does O(1) represent?", "constant", 300, false},
        {"databases", "What operation is used to combine rows from two or more tables based on a related column?", "join", 300, false},
        {"programming", "Who invented Python programming language?", "Guido van Rossum", 400, false},
        {"algorithms", "What is the term for an algorithm that solves a problem by solving smaller instances of the same problem?", "recursion", 400, false},
        {"databases", "What clause is used to filter records in a SQL query?", "WHERE", 400, false}};

    memcpy(questions, temp_questions, sizeof(temp_questions));
}

// Displays available categories and their corresponding question values
void display_categories(void)
{
    printf("Available Categories:\n");
    for (int i = 0; i < NUM_QUESTIONS; ++i)
    {
        if (!already_answered(questions[i].category, questions[i].value))
        {
            printf("%d. %s ($%d)\n", i + 1, questions[i].category, questions[i].value);
        }
    }
}

// Displays the question for a given category and value
void display_question(char *category, int value)
{
    for (int i = 0; i < NUM_QUESTIONS; ++i)
    {
        if (strcmp(questions[i].category, category) == 0 && questions[i].value == value)
        {
            printf("Question: %s\n", questions[i].question);
            break;
        }
    }
}

// Checks if the provided answer is correct
bool valid_answer(char *category, int value, char *answer)
{
    for (int i = 0; i < NUM_QUESTIONS; ++i)
    {
        if (strcmp(questions[i].category, category) == 0 && questions[i].value == value)
        {
            return (strcmp(questions[i].answer, answer) == 0);
        }
    }
    return false;
}

// Checks if a question has already been answered
bool already_answered(char *category, int value)
{
    for (int i = 0; i < NUM_QUESTIONS; ++i)
    {
        if (strcmp(questions[i].category, category) == 0 && questions[i].value == value)
        {
            return questions[i].answered;
        }
    }
    return false;
}

// Marks a question as answered
void mark_answered(char *category, int value)
{
    for (int i = 0; i < NUM_QUESTIONS; ++i)
    {
        if (strcmp(questions[i].category, category) == 0 && questions[i].value == value)
        {
            questions[i].answered = true;
            break;
        }
    }
}

// Checks if all questions have been answered
bool all_questions_answered(void)
{
    for (int i = 0; i < NUM_QUESTIONS; ++i)
    {
        if (!questions[i].answered)
        {
            return false;
        }
    }
    return true;
}

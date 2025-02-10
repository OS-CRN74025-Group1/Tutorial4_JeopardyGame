/*
 * Jeopardy Quiz Game - Header File
 *
 * Custom Implementation for Educational Purposes
 *
 */
#ifndef QUESTIONS_H_
#define QUESTIONS_H_

#include <stdbool.h>

// Constants defining maximum string length and game parameters
#define MAX_LEN 256
#define NUM_CATEGORIES 3
#define NUM_QUESTIONS 12

// Structure for a quiz question
typedef struct
{
    char category[MAX_LEN];
    char question[MAX_LEN * 2];
    char answer[MAX_LEN];
    int value;
    bool answered;
} question;

// Declaration of category array
extern char categories[NUM_CATEGORIES][MAX_LEN];

// Declaration of question array (initialized in setup function)
extern question questions[NUM_QUESTIONS];

// Function prototypes for game logic
extern void initialize_game(void);
extern void display_categories(void);
extern void display_question(char *category, int value);
extern bool valid_answer(char *category, int value, char *answer);
extern bool already_answered(char *category, int value);

#endif /* QUESTIONS_H_ */

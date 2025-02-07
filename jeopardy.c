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
#include <stdbool.h>
#include "questions.h"
#include "players.h"
#include "jeopardy.h"

// Define constants
#define BUFFER_LEN 256  // Maximum length of input buffers
#define NUM_PLAYERS 4    // Number of players in the game
#define MAX_LEN 50       // Max length for player names and category names
#define MAX_CATEGORIES 5 // Number of question categories
#define MAX_QUESTIONS 20 // Total number of questions in the game

// Global variables
player players[NUM_PLAYERS];   // Array to store player information
question questions[MAX_QUESTIONS];  // Array to store questions

// Tokenizes the answer input by extracting the relevant answer part
void tokenize(char *input, char *tokenized)
{
    char *token = strtok(input, " ");
    if (token && (strcmp(token, "what") == 0 || strcmp(token, "who") == 0))
    {
        token = strtok(NULL, " "); // Skip "is"
        if (token && strcmp(token, "is") == 0)
        {
            token = strtok(NULL, ""); // Get the actual answer part
        }
    }
    if (token)
    {
        strcpy(tokenized, token);
    }
    else
    {
        strcpy(tokenized, "");
    }
}

// Displays the game results sorted by score
void show_results(player *players, int num_players)
{
    // Simple bubble sort for ranking players by score
    for (int i = 0; i < num_players - 1; i++)
    {
        for (int j = 0; j < num_players - i - 1; j++)
        {
            if (players[j].score < players[j + 1].score)
            {
                player temp = players[j];
                players[j] = players[j + 1];
                players[j + 1] = temp;
            }
        }
    }

    printf("\nGame Over! Here are the final results:\n");
    for (int i = 0; i < num_players; i++)
    {
        printf("%d. %s - %d points\n", i + 1, players[i].name, players[i].score);
    }
}

int main()
{
    char buffer[BUFFER_LEN];

    // Initialize game
    initialize_game();

    // Get player names
    for (int i = 0; i < NUM_PLAYERS; i++)
    {
        printf("Enter the name of player %d: ", i + 1);
        fgets(players[i].name, MAX_LEN, stdin);
        players[i].name[strcspn(players[i].name, "\n")] = '\0';
        players[i].score = 0;
    }

    // Game loop
    while (!all_questions_answered())
    {
        display_categories();
        printf("Enter player name to choose a category: ");
        fgets(buffer, BUFFER_LEN, stdin);
        buffer[strcspn(buffer, "\n")] = '\0';

        if (!player_exists(players, NUM_PLAYERS, buffer))
        {
            printf("Invalid player name. Try again.\n");
            continue;
        }

        char category[MAX_LEN];
        int value;
        printf("Enter category and value: ");
        scanf("%s %d", category, &value);
        getchar(); // Clear newline character from buffer

        if (already_answered(category, value))
        {
            printf("Question already answered. Choose another.\n");
            continue;
        }

        display_question(category, value);
        printf("Enter your answer: ");
        fgets(buffer, BUFFER_LEN, stdin);
        buffer[strcspn(buffer, "\n")] = '\0';
        
        char tokenized_answer[MAX_LEN];
        tokenize(buffer, tokenized_answer);

        if (valid_answer(category, value, tokenized_answer))
        {
            printf("Correct answer!\n");
            update_score(players, NUM_PLAYERS, buffer, value);
        }
        else
        {
            printf("Incorrect! The correct answer was: %s\n", get_correct_answer(category, value));
        }

        mark_as_answered(category, value);
    }

    // Show final results
    show_results(players, NUM_PLAYERS);
    return EXIT_SUCCESS;
}

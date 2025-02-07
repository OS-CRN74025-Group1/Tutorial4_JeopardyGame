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

// Put macros or constants here using #define
#define BUFFER_LEN 256
#define NUM_PLAYERS 4

// Put global environment variables here

// Processes the answer from the user containing what is or who is and tokenizes it to retrieve the answer.
void tokenize(char *input, char **tokens);

// Displays the game results for each player, their name and final score, ranked from first to last place
void show_results(player *players, int num_players);


int main(int argc, char *argv[])
{
    // An array of 4 players, may need to be a pointer if you want it set dynamically
    player players[NUM_PLAYERS];
    
    // Input buffer and and commands
    char buffer[BUFFER_LEN] = { 0 };

    // Display the game introduction and initialize the questions
    initialize_game();

    // Prompt for players names 
    // initialize each of the players in the array
    for (int i=0; i<NUM_PLAYERS; i++){
    	printf("Enter the name of player %d: ", i+1);
    	fgets(players[i].name, MAX_LEN, stdin);
    	players[i].name[strcspn(players[i].name, "\n")] = '\0';
    	players[i].score = 0;
    }

    // Perform an infinite loop getting command input from users until game ends
    while (fgets(buffer, BUFFER_LEN, stdin) != NULL)
    {
        // Call functions from the questions and players source files
        display_categories();
        printf("Enter player name to choose a category: ");
        fgets(buffer, BUFFER_LEN, stdin);
        buffer[strcspn(buffer, "\n")] = '\0';
        
        if (!player_exists(players, NUM_PLAYERS, buffer)){
        	printf("Invalid player name\n");
        	continue;
        }

        // Execute the game until all questions are answered
        char category[MAX_LEN];
        int value;
        printf("Enter category and value: ");
        scanf("%s %d", category, &value);
        getchar();
        
        if (already_answered(category, value)){
        	printf("Question already answered. Choose another.\n");
        	continue;
        }
        
        display_question(category, value);
        printf("Enter your answer: ");
        fgets(buffer, BUFFER_LEN, stdin);
        buffer[strcspn(buffer, "\n")] = '\0';
        char tokenized_answer[MAX_LEN] = "";
        tokenize(buffer, &tokenized_answer);
        
        if (valid_answer(category, value, tokenized_answer)){
        	printf("Correct answer!\n");
        	update_score(players, NUM_PLAYERS, players[i].name, value);
        }
        else{
        	printf("Incorrect! The correct answer was %s\n: ", questions[i].answer);
        }
        already_answered(category, value);
    }
    
    // Display the final results and exit
    show_results(players, NUM_PLAYERS);
    
    return EXIT_SUCCESS;
}

/*
 * Tutorial 4 Jeopardy Project for SOFE 3950U / CSCI 3020U: Operating Systems
 *
 * Copyright (C) 2015, <GROUP MEMBERS>
 * All rights reserved.
 *
 */
#include "jeopardy.h"
#include "players.h"
#include "questions.h"
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Put macros or constants here using #define
#define BUFFER_LEN 256
#define NUM_PLAYERS 4

// Global Variables
char player_name[BUFFER_LEN];
char answer[BUFFER_LEN];

// Processes the answer from the user containing what is or who is and tokenizes
// it to retrieve the answer.
void tokenize(char *input, char *tokenized_answer) {
  char *token = strtok(input, " ");
  if (token != NULL &&
      (strcmp(token, "who") == 0 || strcmp(token, "what") == 0)) {
    token = strtok(NULL, " "); // Skip "is"
    if (token != NULL) {
      strcpy(tokenized_answer, strtok(NULL, "")); // Get the rest of the string
    }
  } else {
    strcpy(tokenized_answer, input);
  }
}

// Displays the game results for each player, their name and final score, ranked
// from first to last place
void show_results(player *players, int num_players) {
  // Simple bubble sort for ranking players based on their score
  for (int i = 0; i < num_players - 1; i++) {
    for (int j = 0; j < num_players - i - 1; j++) {
      if (players[j].score < players[j + 1].score) {
        player temp = players[j];
        players[j] = players[j + 1];
        players[j + 1] = temp;
      }
    }
  }

  for (int i = 0; i < num_players; i++) {
    printf("%d. %s - %d points\n", i + 1, players[i].name, players[i].score);
  }
}

int main(void) //(int argc, char *argv[])
{
  // An array of 4 players, may need to be a pointer if you want it set
  // dynamically
  player players[NUM_PLAYERS];

  // Display the game introduction and initialize the questions
  initialize_game();

  // Prompt for players names
  // initialize each of the players in the array
  for (int i = 0; i < NUM_PLAYERS; i++) {
    printf("Enter the name of player %d: ", i + 1);
    fgets(players[i].name, MAX_LEN, stdin);
    players[i].name[strcspn(players[i].name, "\n")] = '\0';
    players[i].score = 0;
  }

  // Perform an infinite loop getting command input from users until game ends
  while (!all_questions_answered()) {
    // Call functions from the questions and players source files
    printf("*******************************************************************"
           "***************************\n");
    display_categories();
    printf("*******************************************************************"
           "***************************\n");
    printf("Enter player name to choose a category: ");
    fgets(player_name, BUFFER_LEN, stdin);
    player_name[strcspn(player_name, "\n")] = '\0';

    if (!player_exists(players, NUM_PLAYERS, player_name)) {
      printf("Invalid player name\n");
      continue;
    }

    // Execute the game until all questions are answered
    char category[MAX_LEN];
    int value;
    printf("Enter category and value: ");
    scanf("%s %d", category, &value);
    getchar();

    if (already_answered(category, value)) {
      printf("Question already answered. Choose another.\n");
      continue;
    }

    display_question(category, value);
    printf("Enter your answer: ");
    fgets(answer, BUFFER_LEN, stdin);
    answer[strcspn(answer, "\n")] = '\0';
    char tokenized_answer[MAX_LEN] = "";
    tokenize(answer, tokenized_answer);

    if (valid_answer(category, value, tokenized_answer)) {
      printf("Correct! Player '%s' is awarded %d points \n", player_name,
             value);
      update_score(players, NUM_PLAYERS, player_name, value);

    } else {
      for (int j = 0; j < NUM_QUESTIONS; j++) {
        if (strcmp(questions[j].category, category) == 0 &&
            questions[j].value == value) {
          printf("Incorrect! The correct answer was: %s\n",
                 questions[j].answer);
          break;
        }
      }
    }
    mark_answered(category, value);

    // Display the final results and exit
    printf("*******************************************************************"
           "*********************\n");
    printf("Current Score\n");
    show_results(players, NUM_PLAYERS);
  }

  // Display the final results and exit
  printf("Final Results");
  show_results(players, NUM_PLAYERS);

  return EXIT_SUCCESS;
}

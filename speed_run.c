//
// AED, August 2022 (Tomás Oliveira e Silva)
//
// First practical assignement (speed run)
//
// Compile using either
//   cc -Wall -O2 -D_use_zlib_=0 solution_speed_run.c -lm
// or
//   cc -Wall -O2 -D_use_zlib_=1 solution_speed_run.c -lm -lz
//
// Place your student numbers and names here
//   N.Mec. 107457  Name: Diana Raquel Rodrigues Miranda
//   N.Mec. 107403 Name: João NUno da Silva Luís
//

//
// static configuration
//

#define _max_road_size_ 800 // the maximum problem size
#define _min_road_speed_ 2  // must not be smaller than 1, shouldnot be smaller than 2
#define _max_road_speed_ 9  // must not be larger than 9 (only because of the PDF figure)

//
// include files --- as this is a small project, we include the PDF generation code directly from make_custom_pdf.c
//

#include <math.h>
#include <stdio.h>
#include "../P02/elapsed_time.h"
#include "make_custom_pdf.c"


//
// road stuff
//

static int max_road_speed[1 + _max_road_size_]; // positions 0.._max_road_size_

static void init_road_speeds(void)
{
  double speed;
  int i;

  for (i = 0; i <= _max_road_size_; i++)
  {
    speed = (double)_max_road_speed_ * (0.55 + 0.30 * sin(0.11 * (double)i) + 0.10 * sin(0.17 * (double)i + 1.0) + 0.15 * sin(0.19 * (double)i));
    max_road_speed[i] = (int)floor(0.5 + speed) + (int)((unsigned int)random() % 3u) - 1;
    if (max_road_speed[i] < _min_road_speed_)
      max_road_speed[i] = _min_road_speed_;
    if (max_road_speed[i] > _max_road_speed_)
      max_road_speed[i] = _max_road_speed_;
    
  }
}

//
// description of a solution
//

typedef struct
{
  int n_moves;                        // the number of moves (the number of positions is one more than the number of moves)
  int positions[1 + _max_road_size_]; // the positions (the first one must be zero)
} solution_t;

//
// the (very inefficient) recursive solution given to the students
//

static solution_t solution_1, solution_1_best;
static double solution_1_elapsed_time; // time it took to solve the problem
static unsigned long solution_1_count; // effort dispended solving the problem

static void solution_1_recursion(int move_number, int position, int speed, int final_position)
{
  int i, new_speed;

  // record move
  solution_1_count++;
  solution_1.positions[move_number] = position;
  // is it a solution?
  if (position == final_position && speed == 1)
  {
    // is it a better solution?
    if (move_number < solution_1_best.n_moves)
    {
      solution_1_best = solution_1;
      solution_1_best.n_moves = move_number;
    }
    return;
  }
  // no, try all legal speeds
  for (new_speed = speed - 1; new_speed <= speed + 1; new_speed++)

    if (new_speed >= 1 && new_speed <= _max_road_speed_ && position + new_speed <= final_position)
    {
      for (i = 0; i <= new_speed && new_speed <= max_road_speed[position + i]; i++)
        ;
      if (i > new_speed)
        solution_1_recursion(move_number + 1, position + new_speed, new_speed, final_position);
    }
}

static void solution_1_otimized_recursion(int move_number, int position, int speed, int final_position)
{
  int i, new_speed;

  // record move
  solution_1_count++;
  solution_1.positions[move_number] = position;

  // is it a solution?
  if (position == final_position && speed == 1)
  {
    // is it a better solution?
    if (move_number < solution_1_best.n_moves)
    {
      solution_1_best = solution_1;
      solution_1_best.n_moves = move_number;
    }
    return;
  }
  // no, try all legal speeds
  for (new_speed = speed - 1; new_speed <= speed + 1; new_speed++)

    if (new_speed >= 1 && new_speed <= _max_road_speed_ && position + new_speed <= final_position)
    {
      for (i = 0; i <= new_speed && new_speed <= max_road_speed[position + i]; i++)
        ;
      if (i > new_speed)
      {
        // is worse than current solution? (move_number >>)
        if(move_number > solution_1_best.n_moves){ //vai até aos 60 em segundos
          return;
        }
        // was current state already visited (backtrack)

        solution_1_otimized_recursion(move_number + 1, position + new_speed, new_speed, final_position);
      }
    }

  /*
    se speed + 1 <= max_road_speed[position + speed + 1]
      -> newspeed = speed + 1

      solution_1_recursion(move_number + 1,position + new_speed,new_speed,final_position);

    else if (speed <= max_road_speed[position + speed])
      -> newspeed = speed
      solution_1_recursion(move_number + 1,position + new_speed,new_speed,final_position);

    else {
      -> newspeed = speed - 1
      solution_1_recursion(move_number + 1,position + new_speed,new_speed,final_position);
    }
  */
}

static int respect_limits(int position, int speed,int final_position) //verificar se não execede a velocidade em nenhuma estrada por onde passa
{
  solution_1_count++;
  for(int s = speed; s >= 1; s--){
    for(int i = 1;i<=s;i++){
      if(((position + i) > final_position) || max_road_speed[position + i] < s ){
        return 0;
      }
    }
    position += s;
  }
  return 1;
}

static void solution_2(int move_number, int position, int speed, int final_position)
{
  

  while ((position != final_position))

  {
    solution_1_count++;
    solution_1.positions[move_number] = position;

    if(final_position - (position + 1) != speed){
      if((position + (speed + 1)) < final_position && speed + 1 <= max_road_speed[position + (speed + 1)]){
        /* 
        if ((position+ speed +2) - (position+speed +1) >2 ){ // então, se a diferença entre x casas à frente e x-1 casas à frent2 for maior que um determinado valor,
         // já não vai conseguir travar a tempo, pelo que tem de voltar a trás para decidir melhor
          speed--;
          position--;
        } 
        else{*/
        speed++;
        move_number++;
        position += speed;
      }else if((position + speed) < final_position && speed <= max_road_speed[position + speed]){
        move_number++;
        position += speed;
      }else if((position + (speed -1)) < final_position && speed-1 <= max_road_speed[position + (speed-1)]){
        speed--;
        move_number++;
        position += speed;
      }
      else {
        if(speed > 1){
          speed--;
          position--;
        }
      }
      
    }else { // conditions to brake in final positions
      if(speed > 1){
        speed--;
        move_number++;
        position += speed;
      }else{
        speed = 1;
        move_number++;
        position += speed;
      }
    }
    
    
  }

  move_number++;
  solution_1_count++;
  solution_1.positions[move_number] = position;

  if (move_number < solution_1_best.n_moves)
  {
    solution_1_best = solution_1;
    solution_1_best.n_moves = move_number;
  }
    
  return;

}

static void solution_2_corrigida(int move_number, int position, int speed, int final_position)
{

  while ((position != final_position))
  {
    solution_1_count++;
    solution_1.positions[move_number] = position;

    if (respect_limits(position, speed + 1, final_position) == 1) //verificar se pode subir a velocidade
    {
      speed++;
      move_number++;
      position += speed;

    }else if(respect_limits(position, speed, final_position) == 1) //verificar se pode manter a velocidade
    { 
      move_number++;
      position += speed;
    }else if(respect_limits(position, speed-1, final_position) == 1) //verificar se aumentar subir a velocidade
    {
      speed--;
      move_number++;
      position += speed;
    }else{
      
      if(speed > 1){
          speed--;
          position--;
        }
    }

  }

  //para  pintar a casa final
  move_number++; 
  solution_1_count++;
  solution_1.positions[move_number] = position;

  //número melhor de moves
  if (move_number < solution_1_best.n_moves)
  {
    solution_1_best = solution_1;
    solution_1_best.n_moves = move_number;
  }
  
    
  return;

}

static void solve_1(int final_position)
{
  if (final_position < 1 || final_position > _max_road_size_)
  {
    fprintf(stderr, "solve_1: bad final_position\n");
    exit(1);
  }
  solution_1_elapsed_time = cpu_time();
  solution_1_count = 0ul;
  solution_1_best.n_moves = final_position + 100;
  solution_2_corrigida(0, 0, 0, final_position);
  solution_1_elapsed_time = cpu_time() - solution_1_elapsed_time;
}

//
// example of the slides
//

static void example(void)
{
  int i, final_position;

  srandom(0xAED2022);
  init_road_speeds();
  final_position = 30;
  solve_1(final_position);
  make_custom_pdf_file("example.pdf", final_position, &max_road_speed[0], solution_1_best.n_moves, &solution_1_best.positions[0], solution_1_elapsed_time, solution_1_count, "Plain recursion");
  printf("mad road speeds:");
  for (i = 0; i <= final_position; i++)
    printf(" %d", max_road_speed[i]);
  printf("\n");
  printf("positions:");
  for (i = 0; i <= solution_1_best.n_moves; i++)
    printf(" %d", solution_1_best.positions[i]);
  printf("\n");
}

//
// main program
//

int main(int argc, char *argv[argc + 1])
{
#define _time_limit_ 3600.0
  int n_mec, final_position, print_this_one;
  char file_name[64];

  // generate the example data
  if (argc == 2 && argv[1][0] == '-' && argv[1][1] == 'e' && argv[1][2] == 'x')
  {
    example();
    return 0;
  }
  // initialization
  n_mec = (argc < 2) ? 0xAED2022 : atoi(argv[1]);
  srandom((unsigned int)n_mec);
  init_road_speeds();
  // run all solution methods for all interesting sizes of the problem
  final_position = 1;
  solution_1_elapsed_time = 0.0;
  printf("    + --- ---------------- --------- +\n");
  printf("    |                plain recursion |\n");
  printf("--- + --- ---------------- --------- +\n");
  printf("  n | sol            count  cpu time |\n");
  printf("--- + --- ---------------- --------- +\n");
  while (final_position <= _max_road_size_ /* && final_position <= 20*/)
  {
    print_this_one = (final_position == 10 || final_position == 20 || final_position == 50 || final_position == 100 || final_position == 200 || final_position == 400 || final_position == 800) ? 1 : 0;
    printf("%3d |", final_position);
    // first solution method (very bad)
    if (solution_1_elapsed_time < _time_limit_)
    {
      solve_1(final_position);
      if (print_this_one != 0)
      {
        sprintf(file_name, "%03d_1.pdf", final_position);
        make_custom_pdf_file(file_name, final_position, &max_road_speed[0], solution_1_best.n_moves, &solution_1_best.positions[0], solution_1_elapsed_time, solution_1_count, "Plain recursion");
      }
      printf(" %3d %16lu %9.3e |", solution_1_best.n_moves, solution_1_count, solution_1_elapsed_time);
    }
    else
    {
      solution_1_best.n_moves = -1;
      printf("                                |");
    }
    // second solution method (less bad)
    

    // done
    printf("\n");
    fflush(stdout);
    // new final_position
    if (final_position < 50)
      final_position += 1;
    else if (final_position < 100)
      final_position += 5;
    else if (final_position < 200)
      final_position += 10;
    else
      final_position += 20;
  }
  printf("--- + --- ---------------- --------- +\n");
  return 0;
#undef _time_limit_
}

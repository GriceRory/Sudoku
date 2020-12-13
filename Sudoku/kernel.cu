

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
//#include "cuNet.h"
#include <stdio.h>

struct board {
    int* contents;
    int* guesses;
    int subBoardDimentions;
};

void set_element(board b, int row, int col, int val);
int get_element(board b, int row, int col);
int validBoard(board b);
int validSubBoard(board b, int sub);
int validCol(board b, int col);
int validCol(board b, int row);

int main(){

    return 0;
}




void set_element(board b, int row, int col, int val) {
    b.contents[row * b.subBoardDimentions * b.subBoardDimentions + col] = val;
}
int get_element(board b, int row, int col) {
    return b.contents[row * b.subBoardDimentions * b.subBoardDimentions + col];
}

//rules
int validSubBoard(board b, int sub) {
    int rowStart = (int)(sub / b.subBoardDimentions);
    int colStart = (int)((rowStart - (sub / b.subBoardDimentions)) * b.subBoardDimentions);
    int rowEnd = rowStart + b.subBoardDimentions;
    int colEnd = colStart + b.subBoardDimentions;
    for (int row = rowStart; row < rowEnd; ++row) {
        for (int col = colStart; col < colEnd; ++col) {
            if (!get_element(b, row, col)) {
                continue;
            }
            for (int rowAhead = row + 1; rowAhead < rowEnd; ++rowAhead) {
                for (int colAhead = col + 1; colAhead < colEnd; ++colAhead) {
                    if (get_element(b, row, col) == get_element(b, rowAhead, colAhead)) {
                        return 0;
                    }
                }
            }

        }
    }


    return 1;
}
int validCol(board b, int col) {
    int boardSize = b.subBoardDimentions * b.subBoardDimentions;
    for (int row = 0; row < boardSize; ++row) {
        if (get_element(b, row, col) == 0) { continue; }
        for (int rowAhead = row + 1; rowAhead < boardSize; ++rowAhead) {
            if (get_element(b, row, col) == get_element(b, rowAhead, col)) { return 0; }
        }
    }
    return 1;
}
int validRow(board b, int row) {
    int boardSize = b.subBoardDimentions * b.subBoardDimentions;
    for (int col = 0; col < boardSize; ++col) {
        if (get_element(b, row, col) == 0) { continue; }
        for (int colAhead = col + 1; colAhead < boardSize; ++colAhead) {
            if (get_element(b, row, col) == get_element(b, row, colAhead)) { return 0; }
        }
    }
    return 1;
}
//rules end

int validBoard(board b) {
    //checking each subboard is valid
    int boardDim = b.subBoardDimentions * b.subBoardDimentions;

    for (int subBoard = 0; subBoard < boardDim; ++subBoard) {
        if (!validSubBoard(b, subBoard)) {
            return 0;
        }
    }

    //checking each row is valid
    for (int row = 0; row < boardDim; ++row) {
        validRow(b, row);
    }

    //checking each column is valid
    for (int col = 0; col < boardDim; ++col) {
        validRow(b, col);
    }


    return 1;
}
void sort(int *scores) {
    int i, j, temp;

    for (i = 0; i < 9; ++i){ 
        for (j = 0; j < 9 - i; ++j){
            if (scores[j] > scores[j + 1]){
                temp = scores[j];
                scores[j] = scores[j + 1];
                scores[j + 1] = temp;
            }
        }
    }
}


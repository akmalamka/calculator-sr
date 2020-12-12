from random_word import RandomWords
from nltk.corpus import words
from random import sample

def main():
    digit = ['ONE', 'TWO', 'THREE', 'FOUR', 'FIVE','SIX','SEVEN','EIGHT','NINE', 'ZERO']
    operator = ['PLUS', 'DIVIDE', 'MINUS', 'TIMES']
    # a = 'COUNT'
    f= open("corpus.txt","w+")
    for i in range(len(digit)):
        for j in range(len(operator)):
            for k in range(len(digit)):
                sentence = 'COUNT' + ' ' + digit[i] + ' ' + operator[j] + ' ' + digit[k]
                print(sentence)
                f.write("%s\r\n" % (sentence))

    f.close()

if __name__ == "__main__":
    main()
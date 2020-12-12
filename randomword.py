from random_word import RandomWords
from nltk.corpus import words
from random import sample

n = 6
arr = []
for i in range(100):
    rand_words = ' '.join(sample(words.words(), n))
    arr.append(rand_words.upper())
# print(arr)

f= open("promptsfix.txt","w+")
for i in range(100):
    # f.write(arr[i])
    f.write("*/sample%d " % (i+1))
    f.write("%s\r\n" % (arr[i]))
    
f.close()
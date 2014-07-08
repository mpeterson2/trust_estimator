var devs40 = ["aden","alanjrogers","alysonla","ammeep","arfon","aroben","arrbee","balevine","bigred","cameronmcefee","charliesome","ChrisLundquist","d2fn","dannygreg","derekgr","dgoodlad","erebor","gjtorikian","Haacked","izuzak","jakedouglas","jeejkang","jlord","joewilliams","jordanmccullough","joshaber","joshvera","jspahrsummers","keithduncan","kneath","lizclink","maddox","matthewmccullough","mdiep","niik","paulcbetts","PeterBell","petros","pjhyett","rsese","scottjg","shawndavenport","shiftkey","simonsj","skalnik","sshirokov","tonyjaramillo","TwP","vladoherman","vmg","ymendel"]
var trustMatrix40 = [[0,0,0,0,0,0,0,14,0,0,0,7,7,0,7,0,0,0,0,0,0,0,7,0,21,0,0,0,0,0,35,21,0,0,0,0,0,22,0,14,0,0,0,0,0,0,14,0,14,0,1],[0,0,0,7,7,14,19,14,0,0,6,0,0,115,0,7,0,5,5,7,14,35,5,0,0,64,63,177,107,0,0,14,0,35,0,15,0,0,7,0,7,7,19,0,0,0,0,0,0,12,0],[0,0,0,0,3,0,0,0,0,0,0,0,5,0,3,0,0,3,0,0,0,0,47,0,5,0,0,3,0,0,0,0,5,0,0,0,0,4,5,0,0,0,0,0,0,0,0,0,5,0,0],[0,7,0,0,0,7,28,0,21,0,0,0,0,0,7,0,0,0,7,7,0,7,0,0,0,21,14,7,0,0,0,7,0,0,38,27,0,7,0,0,14,0,50,0,0,3,0,0,0,7,0],[0,7,3,0,0,0,28,0,0,42,56,3,0,0,0,63,7,52,3,17,0,63,8,0,3,0,45,7,21,3,0,0,6,0,0,0,0,14,0,29,7,28,0,0,0,0,14,0,0,0,0],[0,14,0,7,0,0,0,0,0,0,0,0,0,14,3,0,0,0,0,7,0,0,0,0,0,10,7,43,15,0,0,14,0,3,10,0,0,0,0,0,10,0,0,0,0,0,0,0,0,8,0],[0,19,0,28,28,0,0,0,0,28,42,0,0,10,0,28,0,14,7,14,0,28,0,3,0,33,47,41,10,0,0,0,0,7,7,31,0,14,5,14,14,21,49,1,0,0,7,3,0,51,3],[14,14,0,0,0,0,0,0,0,7,7,49,21,14,7,0,0,0,0,3,126,42,0,0,14,0,0,14,7,0,98,0,0,0,3,0,0,35,77,112,0,0,0,0,0,91,63,0,161,66,3],[0,0,0,21,0,0,0,0,0,0,0,0,0,0,42,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,14,0,0,7,0,0,22,0,1,0,0,0,0,0,0,0,0,0,0,0],[0,0,0,0,42,0,28,7,0,0,49,0,0,0,0,42,0,35,0,7,7,50,0,0,0,0,42,0,14,61,0,0,0,0,0,7,0,7,8,21,14,42,0,0,0,7,15,0,0,8,0],[0,6,0,0,56,0,42,7,0,49,0,7,0,3,0,56,0,36,0,28,12,63,0,0,0,3,42,0,21,0,14,0,0,0,0,24,0,14,7,35,21,35,0,8,0,0,21,0,21,12,13],[7,0,0,0,3,0,0,49,0,0,7,0,14,0,7,0,0,0,0,0,19,0,0,0,7,0,0,0,7,0,49,0,0,0,0,30,0,7,77,24,0,0,0,7,0,0,42,0,77,0,0],[7,0,1,0,0,0,0,21,0,0,0,14,0,0,1,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,42,42,0,0,0,0,0,14,21,7,0,0,0,1,0,0,14,0,28,0,0],[0,111,0,0,0,14,10,14,0,0,3,0,0,0,0,0,0,5,19,0,21,28,5,0,0,30,38,156,105,0,0,19,0,40,7,8,0,6,7,0,0,14,19,0,0,0,7,0,0,0,3],[7,0,3,7,0,3,0,7,42,0,0,7,5,0,0,3,0,0,0,0,0,0,0,0,7,0,3,0,0,3,7,28,3,0,7,0,0,29,0,7,0,0,0,3,3,0,10,0,7,0,0],[0,7,0,0,63,0,28,0,0,42,56,0,0,0,3,0,0,35,0,7,0,63,0,0,0,0,42,7,21,0,0,0,0,0,0,0,0,14,0,29,0,35,0,0,5,0,7,0,0,0,5],[0,0,0,0,7,0,0,0,0,0,0,0,0,0,0,0,0,7,0,56,0,0,0,0,5,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,91,73,0,0,70,0,28,63,0,8,49],[0,5,3,0,43,0,14,0,0,35,40,0,0,5,0,35,7,0,5,22,0,35,5,0,1,0,33,5,14,0,0,0,0,0,0,0,3,1,0,15,14,14,5,0,1,1,14,0,0,0,0],[0,5,0,7,3,0,7,0,0,0,0,0,0,19,0,0,0,5,0,0,0,0,5,0,3,7,12,12,0,0,0,3,0,0,12,40,0,4,0,0,0,14,19,0,0,0,7,0,0,0,0],[0,7,0,7,17,7,14,3,0,7,28,0,0,0,0,7,56,22,0,0,0,7,5,0,7,0,14,7,7,3,0,0,0,0,7,14,7,0,0,0,98,77,0,0,49,0,28,49,0,3,48],[0,14,0,0,0,0,0,126,0,7,12,15,0,21,0,0,0,0,0,0,0,42,0,0,7,0,0,21,14,0,84,0,7,0,0,10,7,28,56,70,0,0,0,0,0,98,42,0,98,70,0],[0,35,0,7,63,0,28,42,0,54,63,0,0,28,0,63,0,35,0,7,42,0,0,0,0,0,42,35,49,0,21,0,0,7,7,0,0,15,35,63,0,28,0,0,0,49,12,0,28,28,0],[7,5,21,0,4,0,0,0,0,0,0,0,0,5,0,0,0,5,5,1,0,0,0,0,0,0,8,8,0,0,7,0,6,0,0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0],[0,0,0,0,0,0,3,0,0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,0,0,0,0,0,0,0],[21,0,1,0,3,0,0,14,0,0,0,7,0,0,7,0,5,5,3,7,7,0,0,0,0,0,0,0,0,6,7,0,54,0,0,0,55,7,0,15,0,0,0,0,0,0,21,0,14,0,0],[0,55,0,21,0,10,33,0,0,0,3,0,0,34,0,0,0,0,7,0,0,0,0,0,0,0,78,86,22,10,0,7,0,8,0,12,0,0,0,0,7,0,28,0,0,0,0,0,0,20,0],[0,63,0,14,45,7,47,0,0,42,42,0,0,38,3,42,0,33,12,14,0,42,8,0,0,70,0,127,54,5,0,7,6,14,0,24,0,17,0,7,14,35,26,0,0,0,10,0,0,12,0],[0,138,3,7,7,38,28,14,0,0,0,0,0,133,0,7,0,5,12,7,21,35,8,0,0,82,96,0,121,0,0,16,0,49,0,22,0,10,7,0,7,14,19,0,0,0,0,0,0,12,0],[0,107,0,0,21,19,10,7,0,14,21,7,0,109,0,21,0,14,0,7,14,49,0,0,0,26,50,148,0,0,0,19,0,49,0,5,0,0,14,0,0,14,7,0,0,0,7,0,7,0,0],[0,0,0,0,3,0,0,0,0,61,0,0,0,0,3,0,0,0,0,3,0,0,0,0,6,10,1,0,0,0,0,0,0,0,0,0,0,0,10,0,0,0,0,0,3,0,0,0,0,0,0],[35,0,0,0,0,0,0,98,0,0,14,49,42,0,7,0,0,0,0,0,84,21,7,0,7,0,0,0,0,0,0,35,0,0,0,20,0,43,56,70,0,0,0,7,0,42,56,0,126,28,0],[21,14,0,7,0,14,0,0,14,0,0,0,42,19,28,0,0,0,3,0,0,0,0,0,0,7,7,34,15,0,35,0,0,0,7,5,0,18,0,0,7,0,0,0,0,0,0,0,0,0,0],[0,0,13,0,6,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,7,0,6,0,54,0,6,0,0,0,0,0,0,0,0,0,34,13,1,0,0,0,0,0,0,0,10,0,0,0,0],[0,35,0,0,0,3,7,0,0,0,0,0,0,36,0,0,0,0,0,0,0,7,0,0,0,17,14,50,49,0,0,0,0,0,0,0,0,0,0,1,3,0,7,0,0,0,0,0,0,0,0],[0,0,0,38,0,10,7,3,7,0,0,0,0,7,7,0,0,0,12,7,0,7,0,0,0,0,0,0,0,0,0,7,0,0,0,37,0,7,0,1,7,7,21,0,0,0,7,0,0,0,0],[0,15,0,27,0,0,27,0,0,7,15,3,0,8,0,0,0,0,9,14,1,0,0,0,0,12,20,18,1,0,2,5,0,0,28,0,0,1,2,0,21,7,22,1,0,3,2,0,2,12,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,7,7,0,0,0,64,0,0,0,0,0,0,0,21,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,0],[26,0,8,7,14,0,14,35,26,7,14,7,14,6,33,14,5,5,8,0,28,19,0,0,7,0,17,10,0,0,47,22,13,0,7,5,0,0,33,33,5,7,0,0,5,26,14,5,35,19,8],[0,7,1,0,0,0,1,77,0,12,7,77,21,7,0,0,0,0,0,0,56,35,0,0,0,0,0,7,14,10,56,0,5,0,0,20,0,29,0,35,0,0,0,7,5,63,15,0,84,47,0],[14,0,0,0,33,0,14,112,5,21,35,24,7,0,7,33,0,19,0,0,70,63,0,0,19,0,7,0,0,0,70,0,0,5,5,0,0,29,35,0,0,0,0,5,0,56,49,0,103,35,0],[0,7,0,14,7,10,14,0,0,14,21,0,0,0,0,0,91,14,0,98,0,0,0,0,0,7,14,7,0,0,0,7,0,3,7,21,0,1,0,0,0,119,7,1,70,10,42,63,0,15,56],[0,7,0,0,28,0,21,0,0,42,35,0,0,14,0,35,73,14,14,77,0,28,0,0,0,0,35,14,14,0,0,0,0,0,7,7,0,7,0,0,119,0,7,0,66,1,42,63,0,5,49],[0,19,0,38,0,0,49,0,0,0,0,0,0,19,0,0,0,5,19,0,0,0,5,0,0,28,26,19,7,0,0,0,0,7,21,26,0,0,0,0,7,7,0,0,0,3,7,0,0,14,0],[0,0,0,0,0,0,5,0,0,0,12,7,5,0,3,0,0,0,0,0,0,0,0,44,0,0,0,0,0,0,7,0,0,0,0,10,0,0,7,1,5,0,0,0,0,0,7,0,7,5,0],[0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,5,70,5,0,49,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,1,1,0,70,66,0,0,0,17,21,63,0,0,54],[0,0,0,3,0,0,0,91,0,7,0,0,0,0,0,0,0,5,0,0,98,49,0,0,0,0,0,0,0,0,42,0,0,0,0,3,0,22,63,56,10,5,3,0,17,0,0,0,63,63,0],[14,0,0,0,14,0,7,63,0,19,21,42,14,7,10,7,28,14,7,28,42,8,0,0,21,0,10,0,7,0,56,0,10,0,7,20,7,14,19,49,42,42,7,7,21,0,0,14,91,7,14],[0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,63,0,0,49,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,63,63,0,0,63,0,14,0,0,0,49],[14,0,1,0,0,0,0,161,0,0,21,77,28,0,7,0,0,0,0,0,98,28,0,0,14,0,0,0,7,0,126,0,0,0,0,20,0,35,84,99,0,0,0,7,0,63,91,0,0,49,0],[0,12,0,7,0,4,38,66,0,12,8,0,0,0,0,0,4,0,0,3,70,28,0,0,0,16,12,12,0,0,28,0,0,0,0,12,0,15,43,35,11,1,14,1,0,63,7,0,49,0,3],[5,0,0,0,0,0,3,3,0,0,13,0,0,3,0,5,49,0,0,48,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,56,49,0,0,54,0,14,49,0,3,0]]
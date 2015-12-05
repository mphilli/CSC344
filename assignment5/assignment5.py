# Assignment 5 - CSC 344 - Python
# Michael G. Phillips

import os
import zipfile
import smtplib
import getpass
from email import encoders
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText

### PART I - SYMBOLS FILE

def derive_symbols():
    printlist = []
    for file in os.listdir("C:/Users/Mike/Desktop/csc344"):
    
        # for C file
        if file.endswith(".c"):
            word_list = ['int', 'char', 'void']
            omit = ['(', '{', ';']
            already = []
            f = open(file)
            for line in f:
                for o in omit:
                    line = line.replace(o, " ")
                line_list = line.split()
                for n in range(len(line_list)):
                    if n < len(line_list)-1:
                        word = line_list[n+1]
                        if line_list[n] in word_list and word not in already:              
                            already.append(word)
                            # print('[C,', word + ']')
                            printlist.append('[C, ' + word + ']')
                
        # for Lisp file
        if file.endswith(".lsp"):
            word_list = ['setq', 'setf', 'defun']
            already = []
            f = open(file)
            for line in f:
                line = line.replace('(', '');line = line.replace(')', '')
                line_list = line.split()
                for n in range(len(line_list)):
                    if line_list[n] in word_list and line_list[n+1] not in already:
                        word = line_list[n+1].replace("*", "")
                        already.append(word)
                        # print('[Lisp,', word + ']')
                        printlist.append('[Lisp, ' + word + ']')
                        
        # for Scala file                 
        if file.endswith(".scala"):
            word_list = ['val', 'var', 'def', 'class']
            syms = ['(', ')', ':', '{', '}']
            f = open(file) ;
            already = []
            for line in f:
                for punct in syms:
                    line = line.replace(punct, " ")
                line_list = line.split()
                for n in range(len(line_list)):
                    if n < len(line_list)-1:
                        if line_list[n] in word_list and line_list[n+1] not in already:
                            if not line_list[0].startswith('//'):
                                word = line_list[n+1]
                                already.append(word)
                                # print('[Scala,', word + ']')
                                printlist.append('[Scala, ' + word + ']')
                                
        # for Prolog file
        if file.endswith(".pro"):
            already = []
            syms = ['[', ']', "'", '|', '*', '"', '!', '_']
            num = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
            f = open(file)
            for line in f:
                line = line.replace("(", "( ")
                line_list = line.split()
                for n in range(len(line_list)):
                    #print(line_list[n])
                    word = line_list[n].replace(')', '') #current
                    if word.endswith(',') and not word.startswith("'") and not word in already:
                        already.append(word)
                        word = word.replace(')', ''); word = word.replace(',', '')
                        clear = True
                        for punct in syms:
                            if punct in word: clear = False
                        for currnum in num:
                            if word.startswith(currnum): clear = False
                        if clear == True:
                            # print('[Prolog,', word + ']')
                            printlist.append('[Prolog, ' + word + ']')
                    elif line_list[n].endswith('(') and not word in already:
                        already.append(word)
                        word = word.replace(')', ''); word = word.replace('(', '')
                        clear = True
                        for punct in syms:
                            if punct in word: clear = False
                        for currnum in num:
                            if word.startswith(currnum): clear = False
                        if clear == True:
                            # print('[Prolog,', word + ']')
                            printlist.append('[Prolog, ' + word + ']')

        # for Python file 
        if file.endswith(".py"):
            already = []
            symbols = ["'", ')', '(', ':', ';', ',',
                        '"','==', '#', '!', ']']
            f = open(file)
            for line in f:
                for punct in symbols:
                    line = line.replace(punct, "")
                line_list = line.split()
                for n in range(len(line_list)):
                    line_list
                    if line_list[n] == "=" and not line_list[n-1] in already:
                        if line_list[n-1] != "=" and not '[' in line_list[n-1]:
                            if not ']' in line_list[n-1]:
                                already.append(line_list[n-1])
                                printlist.append('[Python, ' + line_list[n-1] + ']')
                                # print('[Python, ' + line_list[n-1] + ']')
                    if line_list[n-1]=="def" and not line_list[n] in already:
                        if line_list[n] != "=" and not ']' in line_list[n]:
                            already.append(line_list[n])
                            printlist.append('[Python, ' + line_list[n] + ']')
                            # print('[Python, ' + line_list[n] + ']')
                    if line_list[n] == "in" and not line_list[n-1] in already:
                        if line_list[n-1] != "not":
                            if line_list[n] != "=" and not '[' in line_list[n-1]:
                                already.append(line_list[n-1])
                                printlist.append('[Python, ' + line_list[n-1] + ']')
    symbols_file = open('symbols.txt', 'w')
    for line in printlist:
        symbols_file.write(line + '\n')
    symbols_file.close()
    print("symbols.txt created") 
                        
### PART 2 - HTML FILE

def derive_HTML():
    html = open('csc344.html', '+w')
    html.write("<html><body><center><br>")
    html.write("<font size='7'>")
    html.write("<b>Assignments for CSC 344</b><br>")
    html.write("Michael Phillips<hr>") 
    file_type = ['.c', '.lsp', '.scala', '.pro', '.py']
    for n in range(5):
        start = "<br><a href=./a"
        html.write(start + str(n+1) + file_type[n] + '>Assignment ' + str(n+1) + '</a>')
    html.write("<br><br><a href=./symbols.txt>symbols file</a>")
    html.write("<br></center></body></html>")
    html.close()
    print(".html file created")

### PART 3A - ZIP FILE

def derive_zip():
    zipf = zipfile.ZipFile('assignments.zip', 'w')
    path = "./"
    file_names = ['a1.c', 'a2.lsp', 'a3.scala', 'a4.pro', 'a5.py']
    for root, dirs, files in os.walk(path):
        for file in files:
            for name in file_names:
                if name == file:
                    zipf.write(os.path.join(root, file))
    print(".zip created")

### PART 3B - EMAIL
    
def derive_email():
    sender = 'mphilli5@oswego.edu' # school email 
    receivers = input("Email address of .zip file recipient: ")
    password = getpass.getpass() #hidden input
    
    message = MIMEMultipart()
    message["From"] = sender
    message["To"] = receivers
    message["Subject"] = "[CSC 344 - Michael Phillips] Assignments Submission" 
    message.attach(MIMEText("This is my submission of the CSC 344 assignments as a .zip file"))
    part = MIMEBase('application', 'octet-stream')
    part.set_payload(open("assignments.zip", 'rb').read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition',
                    'attachment; filename="assignments.zip"')
    message.attach(part)
	
    try:
       smtpObj = smtplib.SMTP("smtp.gmail.com", 587)
       smtpObj.ehlo(); smtpObj.starttls(); smtpObj.ehlo();
       smtpObj.login(sender, password)
       smtpObj.sendmail(sender, receivers, message.as_string())
       smtpObj.close()
       print("Successfully sent email")
    except smtplib.SMTPException:
       print("Error: unable to send email")

def main():
    derive_symbols()
    derive_HTML()
    derive_zip()
    derive_email()

main()

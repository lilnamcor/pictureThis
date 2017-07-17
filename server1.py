#!/usr/bin/env python
# coding: utf-8
# #
# # Copyright 2010 Alexandre Fiori
# # based on the original Tornado by Facebook
# #
# # Licensed under the Apache License, Version 2.0 (the "License"); you may
# # not use this file except in compliance with the License. You may obtain
# # a copy of the License at
# #
# #     http://www.apache.org/licenses/LICENSE-2.0
# #
# # Unless required by applicable law or agreed to in writing, software
# # distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# # WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# # License for the specific language governing permissions and limitations
# # under the License.
#
import cyclone.web
import sys
#
from twisted.internet import reactor
from twisted.python import log
from twisted.enterprise import adbapi

from datetime import datetime
#
#
class MainHandler(cyclone.web.RequestHandler):
    def get(self):
        self.write("Hello, world")

    def post(self):
        print self.get_argument('username', 'No data received')
        print self.get_argument('password', 'No data received')
        self.write("Fuck this gay earth")

class LoginHandler(cyclone.web.RequestHandler):
    def post(self):
        username_arg = self.get_argument('username', None)
        password_arg = self.get_argument('password', None)
        # read from some DB
        f = open('confidential.txt', 'r')
        for line in f:
            split = line.split(',')
            username = split[0]
            password = split[1]
            if username == username_arg:
                if password == password_arg:
                    self.write("success")
                    break
                else:
                    self.write("fail")
                    break
        print username_arg
        print password_arg
        print self.request.uri
        self.write("fail")

def create_entry(*args):
    toReturn = ""
    for elem in args:
        if elem == None:
            return None
        toReturn += elem + ","
    return toReturn[:-1] + '\n'

class SignUpHandler(cyclone.web.RequestHandler):
    def post(self):
        a = datetime.now()
        print self.request.uri
        username_arg = self.get_argument('username', None)
        password_arg = self.get_argument('password', None)
        first = self.get_argument('first', None)
        last = self.get_argument('last', None)
        email = self.get_argument('email', None)
        birthday = self.get_argument('birthday', None)
        f = open('confidential.txt', 'r')
        for line in f:
            split = line.split(',')
            username = split[0]
            if username == username_arg:
                self.write("exists")
                return
        f = open('confidential.txt', 'a')
        entry = create_entry(username_arg, password_arg, first, last, email, birthday)
        if entry:
            f.write(entry)
            f.close()
            print datetime.now() - a
            self.write("success")
        else:
            print datetime.now() - a
            self.write("fail")

class FriendHandler(cyclone.web.RequestHandler):

    def printResult(l):
        print "HELLO MOTO"
        print l
        if l:
            print "CUINT"
        else:
            print "No such user"

    def get(self):
        cp = adbapi.ConnectionPool("pyPgSQL.PgSQL", database="itaireuveni")
        print cp
        try:
            temp = cp.runQuery("SELECT * FROM users").addCallback(printResult)
            print "SHIT"
            print temp
            temp
            self.write("FUCK OFF")
            self.write(cyclone.web.RequestHandler.get_argument(self, "self"))
        except:
            print "FUCK"


if __name__ == "__main__":
    application = cyclone.web.Application([
        (r"/", MainHandler),
        (r"/login", LoginHandler),
        (r"/signup", SignUpHandler),
        (r"/friends", FriendHandler)
    ])

    log.startLogging(sys.stdout)
    reactor.listenTCP(8080, application, interface="127.0.0.1")
    reactor.run()

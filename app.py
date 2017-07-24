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
from twisted.internet import defer, reactor
from twisted.python import log
from twisted.enterprise import adbapi

from datetime import datetime
import json
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

    @defer.inlineCallbacks
    def post(self):
        cp = adbapi.ConnectionPool("pyPgSQL.PgSQL", database="itaireuveni")
        username = self.get_argument('username')
        password = self.get_argument('password')
        user = yield cp.runQuery("SELECT id FROM users WHERE username='" + username + "' and password='" + password + "'")
        if len(user) == 1:
            self.write("SUCCESS")
        else:
            self.write("FAIL")

def create_users_table_entry(username, password, first, last, email, gender, dob):
    stmt = "INSERT INTO USERS (username,password,first,last,email,gender,dob) VALUES ('"
    stmt += username + "','"
    stmt += password + "','"
    stmt += first + "','"
    stmt += last + "','"
    stmt += email + "','"
    stmt += gender + "','"
    stmt += dob + "')"
    return stmt


class SignUpHandler(cyclone.web.RequestHandler):

    @defer.inlineCallbacks
    def post(self):
        cp = adbapi.ConnectionPool("pyPgSQL.PgSQL", database="itaireuveni")
        a = datetime.now()
        username = self.get_argument('username')
        user = yield cp.runQuery("SELECT id FROM users WHERE username='" + username + "'")
        if len(user) > 0:
            self.write("ALREADY EXISTS")
        else:
            password = self.get_argument('password')
            first = self.get_argument('first')
            last = self.get_argument('last')
            email = self.get_argument('email')
            gender = self.get_argument('gender')
            dob = self.get_argument('dob')
            try:
                stmt = create_users_table_entry(username, password, first, last, email, gender, dob)
                cp.runOperation(stmt)
                self.write("SUCCESS")
            except:
                self.write("ERROR")

class FriendHandler(cyclone.web.RequestHandler):

    @defer.inlineCallbacks
    def get(self):
        cp = adbapi.ConnectionPool("pyPgSQL.PgSQL", database="itaireuveni")
        try:
            username = self.get_argument('username')
            # get list of this users friends
            friends = yield cp.runQuery("SELECT friends FROM users WHERE username='" + username + "'")
            list_of_friends = []
            for user in json.loads(friends[0][0]):
                first_name = yield cp.runQuery("SELECT first FROM users WHERE id='" + str(user) + "'")
                list_of_friends.append(first_name[0][0])
            self.write('SUCCESS')
            self.write(','.join(name for name in list_of_friends))
        except:
            print "ERROR"


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

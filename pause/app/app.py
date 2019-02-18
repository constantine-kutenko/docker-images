#!/usr/bin/env python

from BaseHTTPServer import BaseHTTPRequestHandler, HTTPServer
import SocketServer
import os

class Handler(BaseHTTPRequestHandler):
    def _set_headers(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

    def do_GET(self):
        self._set_headers()
        self.wfile.write("<html><head></head><body>OK</body></html>")

    def do_HEAD(self):
        self._set_headers()
        
    def do_POST(self):
        self._set_headers()
        self.wfile.write("<html><head></head><body>OK</body></html>")
        
if __name__ == "__main__":
    port = int(os.getenv('PORT', 3000))
    httpd = HTTPServer(("", port), Handler)
    print "HTTP server is listening on port", port
    httpd.serve_forever()

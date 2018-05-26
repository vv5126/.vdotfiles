#!/usr/bin/env python3.6
# IRC Bot Skeleton
# Developed by acidvegas in Python
# https://github.com/acidvegas/irc
# irc.py

import socket
import time

# Connection
server     = 'irc.ubuntu.com'
port       = 6697
proxy      = None # Proxy should be a Socks5 in IP:PORT format.
use_ipv6   = False
use_ssl    = True
ssl_verify = False
vhost      = None
channel    = None
key        = None

# Certificate
cert_key  = None
cert_file = None
cert_pass = None

# Identity
nickname = 'vhelper'
username = 'user'
realname = 'Python IRC Bot'

# Login
nickserv_password = 'asd456'
network_password  = None
operator_password = None

# Settings
user_modes = None

# Formatting Control Characters / Color Codes
bold        = '\x02'
italic      = '\x1D'
underline   = '\x1F'
reverse     = '\x16'
reset       = '\x0f'
white       = '00'
black       = '01'
blue        = '02'
green       = '03'
red         = '04'
brown       = '05'
purple      = '06'
orange      = '07'
yellow      = '08'
light_green = '09'
cyan        = '10'
light_cyan  = '11'
light_blue  = '12'
pink        = '13'
grey        = '14'
light_grey  = '15'

def debug(msg):
	print(f'{get_time()} | [~] - {msg}')

def error(msg, reason=None):
	if reason:
		print(f'{get_time()} | [!] - {msg} ({reason})')
	else:
		print(f'{get_time()} | [!] - {msg}')

def error_exit(msg):
	raise SystemExit(f'{get_time()} | [!] - {msg}')

def get_time():
	return time.strftime('%I:%M:%S')

class IRC(object):
	def __init__(self):
		self.sock = None

	def action(self, chan, msg):
		self.sendmsg(chan, f'\x01ACTION {msg}\x01')

	def color(self, msg, foreground, background=None):
		if background:
			return f'\x03{foreground},{background}{msg}{reset}'
		else:
			return f'\x03{foreground}{msg}{reset}'

	def connect(self):
		try:
			self.create_socket()
			self.sock.connect((server, port))
			self.register()
		except socket.error as ex:
			error('Failed to connect to IRC server.', ex)
			self.event_disconnect()
		else:
			self.listen()

	def create_socket(self):
		family = socket.AF_INET6 if use_ipv6 else socket.AF_INET
		if proxy:
			proxy_server, proxy_port = proxy.split(':')
			self.sock = socks.socksocket(family, socket.SOCK_STREAM)
			self.sock.setblocking(0)
			self.sock.settimeout(15)
			self.sock.setproxy(socks.PROXY_TYPE_SOCKS5, proxy_server, int(proxy_port))
		else:
			self.sock = socket.socket(family, socket.SOCK_STREAM)
		if vhost:
			self.sock.bind((vhost, 0))
		if use_ssl:
			ctx = ssl.SSLContext()
			if cert_file:
				ctx.load_cert_chain(cert_file, cert_key, cert_pass)
			if ssl_verify:
				ctx.verify_mode = ssl.CERT_REQUIRED
				ctx.load_default_certs()
			else:
				ctx.check_hostname = False
				ctx.verify_mode = ssl.CERT_NONE
			self.sock = ctx.wrap_socket(self.sock)

	def ctcp(self, target, data):
		self.sendmsg(target, f'\001{data}\001')

	def event_connect(self):
		if user_modes:
			self.mode(nickname, '+' + user_modes)
		if nickserv_password:
			self.identify(nickname, nickserv_password)
		if operator_password:
			self.oper(username, operator_password)
		if channel:
			self.join_channel(channel, key)
			self.raw('LIST')

	def event_ctcp(self, nick, chan, msg):
		pass

	def event_disconnect(self):
		self.sock.close()
		time.sleep(15)
		self.connect()

	def event_invite(self, nick, chan):
		pass

	def event_join(self, nick, chan):
		pass

	def event_kick(self, nick, chan, kicked):
		if kicked == nickname and chan == channel:
			time.sleep(3)
			self.join_channel(chan, key)

	def event_message(self, nick, chan, msg):
		if msg == '!test':
			self.sendmsg(chan, 'It works!')

	def event_nick_in_use(self):
		error('The bot is already running or nick is in use.')

	def event_part(self, nick, chan):
		pass

	def event_private(self, nick, msg):
		self.vdeal(nick, msg)

	def event_quit(self, nick):
		pass

	def handle_events(self, data):
		args = data.split()
		if data.startswith('ERROR :Closing Link:'):
			raise Exception('Connection has closed.')
		elif args[0] == 'PING':
			self.raw('PONG ' + args[1][1:])
		elif args[1] == '001':
			self.event_connect()
		elif args[1] == '433':
			self.event_nick_in_use()
		elif args[1] == 'INVITE':
			nick = args[0].split('!')[0][1:]
			chan = args[3][1:]
			self.event_invite(nick, chan)
		elif args[1] == 'JOIN':
			nick = args[0].split('!')[0][1:]
			chan = args[2][1:]
			self.event_join(nick, chan)
		elif args[1] == 'KICK':
			nick   = args[0].split('!')[0][1:]
			chan   = args[2]
			kicked = args[3]
			self.event_kick(nick, chan, kicked)
		elif args[1] == 'PART':
			nick = args[0].split('!')[0][1:]
			chan = args[2]
			self.event_part(nick, chan)
		elif args[1] == 'PRIVMSG':
			nick = args[0].split('!')[0][1:]
			#ident = args[0].split('!')[1]
			#host  = ident.split('@')[1]
			chan = args[2]
			msg  = data.split(f'{args[0]} PRIVMSG {chan} :')[1]
			if msg.startswith('\001'):
				self.event_ctcp(nick, chan, msg)
			elif chan == nickname:
				self.event_private(nick, msg)
			else:
				self.event_message(nick, chan, msg)
		elif args[1] == 'QUIT':
			nick = args[0].split('!')[0][1:]
			self.event_quit(nick)

	def identify(self, nick, passwd):
		self.sendmsg('nickserv', f'identify {nick} {passwd}')

	def invite(self, nick, chan):
		self.raw(f'INVITE {nick} {chan}')

	def join_channel(self, chan, key=None):
		self.raw(f'JOIN {chan} {key}') if key else self.raw('JOIN ' + chan)

	def listen(self):
		while True:
			try:
				data = self.sock.recv(1024).decode('utf-8')
				for line in (line for line in data.split('\r\n') if line):
					# debug(line)
					if len(line.split()) >= 2:
						self.handle_events(line)
			except (UnicodeDecodeError,UnicodeEncodeError):
				pass
			except Exception as ex:
				error('Unexpected error occured.', ex)
				break
		self.event_disconnect()

	def mode(self, target, mode):
		self.raw(f'MODE {target} {mode}')

	def nick(self, nick):
		self.raw('NICK ' + nick)

	def notice(self, target, msg):
		self.raw(f'NOTICE {target} :{msg}')

	def oper(self, user, passwd):
		self.raw(f'OPER {user} {passwd}')

	def part(self, chan, msg=None):
		self.raw(f'PART {chan} {msg}') if msg else self.raw('PART ' + chan)

	def quit(self, msg=None):
		self.raw('QUIT :' + msg) if msg else self.raw('QUIT')

	def raw(self, msg):
		self.sock.send(bytes(msg + '\r\n', 'utf-8'))

	def register(self):
		if network_password:
			self.raw('PASS ' + network_password)
		self.raw(f'USER {username} 0 * :{realname}')
		self.nick(nickname)

	def sendmsg(self, target, msg):
		self.raw(f'PRIVMSG {target} :{msg}')

	def topic(self, chan, text):
		self.raw(f'TOPIC {chan} :{text}')

	def vdeal(self, nick, msg):
		print ('wgao ' + msg)
		self.sendmsg(nick, 'It works!')
# Main
if proxy:
	try:
		import socks
	except ImportError:
		error_exit('Missing PySocks module! (https://pypi.python.org/pypi/PySocks)')
if use_ssl:
	import ssl
IRC().connect()
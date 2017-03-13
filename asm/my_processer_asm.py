infile = open('in.txt', 'r')
outfile = open('out.txt', 'w')
content = infile.read().lower()
sent = content.split('\n')
print 'assemble code:\n'
for k in sent:
	print k
print '\nassembleing...\n'
for ins in sent:
	line = ""
	token = ins.split(' ');
	t = token[0]
	if t == 'nop':
		line += '00000_'
		token.append('r0')
		token.append('r0')
		token.append('r0')
	elif t == 'halt':
		line += '00001_'
		token.append('r0')
		token.append('r0')
		token.append('r0')

	elif t == 'load':
		line += '00010_'
	elif t == 'store':
		line += '00011_'

	elif t == 'ldih':
		line += '10000_'
	elif t == 'ldil':
		line += '10011_'
	elif t == 'add':
		line += '01000_'
	elif t == 'addi':
		line += '01001_'
	elif t == 'addc':
		line += '10001_'
	elif t == 'sub':
		line += '01010_'
	elif t == 'subi':
		line += '01011_'
	elif t == 'subc':
		line += '10010_'

	elif t == 'cmp':
		line += '01100_'
		token.insert(1, 'r0')
	elif t == 'and':
		line += '01101_'
	elif t == 'or':
		line += '01110_'
	elif t == 'xor':
		line += '01111_'

	elif t == 'not':
		line += '10100_'
		token.append('r0')
	elif t == 'nand':
		line += '10101_'
	elif t == 'nor':
		line += '10110_'
	elif t == 'nxor':
		line += '10111_'

	elif t == 'sll':
		line += '00100_'
	elif t == 'srl':
		line += '00110_'
	elif t == 'sla':
		line += '00101_'
	elif t == 'sra':
		line += '00111_'

	elif t == 'jump':
		line += '11000_'
		token.insert(1, 'r0')
	elif t == 'jmpr':
		line += '11001_'
	elif t == 'bz':
		line += '11010_'
	elif t == 'bnz':
		line += '11011_'
	elif t == 'bn':
		line += '11100_'
	elif t == 'bnn':
		line += '11101_'
	elif t == 'bc':
		line += '11110_'
	elif t == 'bnc':
		line += '11111_'

	o = token[1][1]
	if o == '0':
		line += '000_'
	elif o == '1':
		line += '001_'
	elif o == '2':
		line += '010_'
	elif o == '3':
		line += '011_'
	elif o == '4':
		line += '100_'
	elif o == '5':
		line += '101_'
	elif o == '6':
		line += '110_'
	elif o == '7':
		line += '111_'

	if token[2][0] == 'r':
		o = token[2][1]
		if o == '0':
			line += '0000_'
		elif o == '1':
			line += '0001_'
		elif o == '2':
			line += '0010_'
		elif o == '3':
			line += '0011_'
		elif o == '4':
			line += '0100_'
		elif o == '5':
			line += '0101_'
		elif o == '6':
			line += '0110_'
		elif o == '7':
			line += '0111_'
	else:
		o = token[2]
		k = bin(int(o))[2:]
		for i in range(4 - len(k)):
			line += '0'
		line += k
		line += '_'

	if token[3][0] == 'r':
		o = token[3][1]
		if o == '0':
			line += '0000'
		elif o == '1':
			line += '0001'
		elif o == '2':
			line += '0010'
		elif o == '3':
			line += '0011'
		elif o == '4':
			line += '0100'
		elif o == '5':
			line += '0101'
		elif o == '6':
			line += '0110'
		elif o == '7':
			line += '0111'
	else:
		o = token[3]
		k = bin(int(o))[2:]
		for i in range(4 - len(k)):
			line += '0'
		line += k

	outfile.write(line)
	print line
print
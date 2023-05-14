import sys
def help_print():
    print("[USAGE] python3 dumphex.py <input file> <output file>", file=sys.stderr)
if len(sys.argv) <= 2:
    print("Bad usage")
    help_print()
    exit()
try:
    with open(sys.argv[1], "rb") as f:
        insts:bytes = f.read()
        insts = [ insts[i*4:i*4 + 4][::-1].hex() for i in range(len(insts) // 4)]
        output_file = open(sys.argv[2], "w")
        for inst in insts:
            print(inst, file=output_file)
except FileNotFoundError:
    help_print()
    
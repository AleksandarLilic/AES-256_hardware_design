import sys
import checker_gen

if len(sys.argv) < 2:
    print("Usage: python tests_gen.py <number of runs>")
    sys.exit(1)

NUMBER_OF_RUNS = int(sys.argv[1])
for i in range(NUMBER_OF_RUNS):
    seed = i + 100
    id = f"{i:03}"
    checker_gen.main(seed, id)

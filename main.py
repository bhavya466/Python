## this code validated if entered credit card numbers are valid or invalid
import re
checking = re.compile(
    r"^"
    r"(?!.*(\d)(-?\1){3})"
    r"[456]"
    r"\d{3}"
    r"(?:-?\d{4}){3}"
    r"$")

for i in range(int(input().strip())):
    print("Valid" if checking.search(input().strip()) else "Invalid")

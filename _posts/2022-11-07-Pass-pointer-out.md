# Problem
I used `a = &ta`  for appending to array variable in some function, then I expected that change effected original variable which was pass to the function. 
You can check the behavior in `noAppendD`  of sample code.

# Solution
`*a = ta` is working.

# Sample Code
```go
package main

import (
	"fmt"
)

func appendD(a *[]string) {
	fmt.Println("begin appendD===")
	ta := append(*a, "d")
	print(&ta); fmt.Println(" ta: ", ta)
	*a = ta # Important
	print(a); fmt.Println(" a: ", a)
	fmt.Println("end appendD===")
}

func noAppendD(a *[]string) {
	fmt.Println("begin noAppendD===")
	ta := append(*a, "d")
	print(&ta); fmt.Println(" ta: ", ta)
	a = &ta
	print(a); fmt.Println(" a: ", a)
	fmt.Println("end noAppendD===")
}

func main() {
	porga := &[]string{"a", "b", "c"}
	fmt.Println("porga: ", porga)
	print(porga); fmt.Println(" porga addr")

	noAppendD(porga)
	print(porga)
	fmt.Println(" After noAppendD, porga: ", porga)

	appendD(porga)
	print(porga)
	fmt.Println(" After appendD, porga: ", porga)
}
```
## Output
```
porga:  &[a b c]
0xc0000b0018 porga addr
begin noAppendD===
0xc0000b0048 ta:  [a b c d]
0xc0000b0048 a:  &[a b c d]
end noAppendD===
0xc0000b0018 After noAppendD, porga:  &[a b c]
begin appendD===
0xc0000a4e68 ta:  [a b c d]
0xc0000b0018 a:  &[a b c d]
end appendD===
0xc0000b0018 After appendD, porga:  &[a b c d]
```

# References
* [A Tour of Go Pointers](https://go.dev/tour/moretypes/1)
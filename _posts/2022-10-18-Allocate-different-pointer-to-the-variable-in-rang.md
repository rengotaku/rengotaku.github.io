# Problem
I'd like to count up, but not working below:
```go
package main

import (
	"fmt"
)

type obj struct {
	key     string
	counter int
}

func goodcase(objs []obj) map[string]*obj {
	fmt.Println("*** good case ***")
	grpMap := make(map[string]*obj)
	for i, _ := range objs {
		v := objs[i] // important
		if grpMap[v.key] != nil {
			grpMap[v.key].counter += 1
		} else {
			print(&v)
			fmt.Println(v)
			grpMap[v.key] = &v
		}
	}

	return grpMap
}

func badcase(objs []obj) map[string]*obj {
	fmt.Println("*** bad case ***")
	grpMap := make(map[string]*obj)
	for _, v := range objs {
		if grpMap[v.key] != nil {
			grpMap[v.key].counter += 1
		} else {
			print(&v)
			fmt.Println(v)
			grpMap[v.key] = &v
		}
	}

	return grpMap
}

func printMap(grpMap map[string]*obj) {
	for k, v := range grpMap {
		fmt.Println(k, v)
	}
}

func main() {
	objs := []obj{
		obj{"a", 1},
		obj{"b", 1},
		obj{"a", 1},
		obj{"c", 1},
		obj{"c", 1},
	}

	fmt.Println("objs: ", objs)

	printMap(badcase(objs))
	printMap(goodcase(objs))

}
```
Output:
```
objs:  [{a 1} {b 1} {a 1} {c 1} {c 1}]
*** bad case ***
0xc0000100c0{a 1}
0xc0000100c0{b 1}
0xc0000100c0{c 1}
b &{c 2}
c &{c 2}
a &{c 2}
...
```

# How
Look at the `goodcase` function.
Important is  `v := objs[i]`, what you allocate different pointer.

Output of example code in Problem section:
```
*** good case ***
0xc000010168{a 1}
0xc000010198{b 1}
0xc0000101e0{c 1}
a &{a 2}
b &{b 1}
c &{c 2}
```

# References
* [Golang range and pointers](https://tam7t.com/golang-range-and-pointers/)
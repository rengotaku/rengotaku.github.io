# Problem
I forgot to be multipled by "time.Second", when I compared the elapsed time with which I specific, such as `sndT.Sub(fstT) > time.Duration(10)`.

# Which you can know how to be occured
```go
package main

import (
	"log"
	"time"
)

func main() {
	fstT := time.Now()
	log.Println("fstT: ", fstT)
	sndT := time.Now().Add(time.Duration(5) * time.Second)
	log.Println("sndT: ", sndT)

	if sndT.Sub(fstT) > time.Duration(10) {
		log.Println("time.Duration(10) is ", time.Duration(10), ", unit is 'ns', this is why you pass through this condition.")
	}
	if !(sndT.Sub(fstT) > time.Duration(10)*time.Second) {
		log.Println("You have to be multiplied by 'time.Second' to become second(s) unit.")
	}
}
```
Output
```
2009/11/10 23:00:00 fstT:  2009-11-10 23:00:00 +0000 UTC m=+0.000000001
2009/11/10 23:00:00 sndT:  2009-11-10 23:00:05 +0000 UTC m=+5.000000001
2009/11/10 23:00:00 time.Duration(10) is  10ns , unit is 'ns', this is why you pass through this condition.
2009/11/10 23:00:00 You have to be multiplied by 'time.Second' to become second(s) unit.
```
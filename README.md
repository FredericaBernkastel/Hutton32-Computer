**Hutton32b** - (almost) backward compatible modification of Hutton32 CA. [[Ruletable](doc/Hutton32b.rule)]<br>
- The `<25,10,11,12,9>` state (and rotations) will now work as a very small (3x3) XNOR logic gate.
- Added forgotten set of rules `<21,0,0,0,28,21>`, to make the special transitive state consistent with the regular one. It will receive signal, even if can't transmit one.
- Added forgotten set of rules `<29,12,9,0,13,25>`.

[`Component basis:`](component-basis.rle)

![Hutton32](doc/component-basis.png)
<br><br><br>
[`8-bit decimal counter:`](advanced%20counter%20v2%20(synchronous%20ver.).rle)

![Hutton32](doc/advanced%20counter%20v2~marked.png)
<br><br><br>
[`16x16 display:`](misc/16x16%20display.mc)

![Hutton32](doc/16x16%20display.png)
<br><br><br>
[`32x32 display (serial interface):`](misc/32x32%20display.mc)

![Hutton32](doc/32x32%20display.png)
<br><br><br>
[`Efficient ROM and address decoder:`](misc/256k%20Segmented%20ROM.mc)

![Hutton32](doc/256k%20Segmented%20ROM.png)
<br><br><br>
[`Efficient demultiplexer:`](misc/efficient_demultiplexer.mc)

![Hutton32](doc/efficient_demultiplexer.png)


<br><br><br>
### Memories of the Hutton wars
![Hutton32](doc/memes/adder%20meme.png)
![Hutton32](doc/memes/BIN2BCD%20meme.png)
![Hutton32](doc/memes/advanced%20counter%20meme.png)
<img src="doc/memes/not%20meme.jpg" alt="Hutton32" width="312">
![Hutton32](doc/memes/Segmented%20ROM.png)
![Hutton32](doc/memes/wirecross.png)

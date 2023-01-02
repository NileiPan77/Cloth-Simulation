

# Physically-based simulation

Name: Nilei Pan

x500: pan00128

### Part1

Implemented:

- Cloth Simulation
- 3D simulation
- High-quality rendering
- Air Drag for cloth



- No air drag
  - <img src=".\nodrag.gif" alt="nodrag" style="zoom:25%;" />

-  With air drag
  - <img src=".\air0.gif" alt="air0" style="zoom:25%;" />

- Air 30 unit/s
  - <img src=".\air30.gif" alt="air30" style="zoom:25%;" />
- Air 100 unit/s
  - <img src=".\air100.gif" alt="air100" style="zoom:25%;" />



- Texturing, 3d simulation, 3d light and natural camera demo.
  - <img src=".\demo.gif" alt="demo" style="zoom:50%;" />



### Part2

Implemented:

- SPH Fluid Simulation

![water](.\water.gif)



## Difficulties

Part1: air drag, deciding which points considered as one surface and calculate the air force based on that area requires careful decision and had to take edge cases into account and avoid some nodes will receive air drag more than one time.

Part2: Since "collision" is achieved by adding a pushing force within particles, it makes actual collision test and handling extra difficult with other non-water objects. It also made realistic behaviors like plunging and splashing with non water object hard to achieve.

# License 

Shelf, tap Image by <a href="https://pixabay.com/users/publicdomainpictures-14/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2192">PublicDomainPictures</a> from <a href="https://pixabay.com//?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=2192">Pixabay</a>

Duck Image from <a href="https://www.cleanpng.com/">cleanpng </a>

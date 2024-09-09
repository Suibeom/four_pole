Made with [LÖVE](https://love2d.org/) 

This is a interactive demonstration of the physics of a quadrupole mass spectrometer. Little ions march across the screen in high-frequency-modulated electric field between two pairs of charged poles parallel to their direction of movement. We see a top-down and side-on view of the particles as they move through the field, with their mass/charge ratio between, as they move towards the collector target on the right-hand side of the screen

The histogram of white dots on the top of the screen shows the proportion of particles of a given mass/charge ratio that have hit the collector target.

The red and blue histogram just below it shows the proportion of particles that have flown off and hit one of the pairs of charged poles running parallel to the particle beam (red for the pair in the plane of the top view, and blue for the other pair)


Equations of motion refenced from Mass Spectrometry, Principles and Applications 3rd Ed by de Hoffmann and Stroobant

Run from your command line with `love .` in the repository directory

Keyboard controls:
q/a: increment/decrement frequency
w/s: increase/decrease AC voltage
e/d: increase/decrease DC offset voltage
r/f: Change particle spawn mode:
- uniformly spawn particles between 1 and 100 mass/charge ratio
- uniformly spawn particles between 10 and 100 mass/charge ratio by tens
- Spawn only particles of a specific mass/charge ratio

o: Reset statistics and particles
p: Save a png screenshot with your frequency/ac/dc in the filename
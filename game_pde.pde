float canv_w = 1900;
float canv_h = 1000;
int game_score = 0; 

float drum_w = 400;
float drum_h = 100;
float note_speed = 25;

// Note Positions
float OVER_DRUM_0 = 110;
float OVER_DRUM_1 = 570;
float OVER_DRUM_2 = 1030;
float OVER_DRUM_3 = 1490;

void setup() {
	size(canv_w,canv_h);

	notes[0] = new Note(OVER_DRUM_1,0,300,70,255,255,255);
	//notes[1] = new Note(OVER_DRUM_0,0,300,70,255,255,255);
	for (int i = 1; i<notes.length; i++) {
		notes[i] = new Note();
	}	
}

// Set up Drums
Drum d0 = new Drum(60,850,drum_w,drum_h,255,0,0);
Drum d1 = new Drum(520,850,drum_w,drum_h,0,255,0);
Drum d2 = new Drum(980,850,drum_w,drum_h,0,0,255);
Drum d3 = new Drum(1440,850,drum_w,drum_h,255,255,0);
Drum[] drums = {d0,d1,d2,d3};

// Set up Notes
Note[] notes = new Note[15];

// Set up Drumsticks
DrumStick ds1 = new DrumStick(0,0);

void draw() {
	background(0);
	
	// Show Text
	fill(255,0,0);
	textSize(55);
	text("Score: " + game_score,60,60);

	// Draw the Drums
	for (int i = 0; i<drums.length; i++) {
		drums[i].draw();
	}

	// Draw the Notes
	for (int i = 0; i<notes.length; i++) {
		notes[i].update();
		notes[i].draw();
	}

	// Draw Drumsticks
	ds1.draw();

	// Check with Drums are Stuck
	ArrayList drums_hit = determine_drums_hit();

	// Highlight Them
	highlight_drums(drums_hit);

	// Drum + Note + Drumstick Collisions
	void drum_note_stick_collision(drums_hit);

}

void update_score() {
	// Just to test my collision logic
	game_score += 10;
}

void drum_note_stick_collision(ArrayList drums_hit) {
	for (int i = 0; i<drums_hit.size(); i++) {
		Drum d = drums[drums_hit.get(i)];		

		for (int j = 0; j<notes.length; j++) {
			if (!notes[j].exists) {				
				continue;
			}

			if (drum_note_collision(d,notes[j])) {
				update_score();
			}
 		}
	}
}

boolean drum_note_collision(Drum d, Note n) {
	if (d.x > n.x+n.width) {return false;}
	if (d.x+d.width < n.x) {return false;}
	if (d.y > n.y+n.height) {return false;}
	if (d.y+d.height < n.y) {return false;}
	return true;
}

ArrayList determine_drums_hit() {
	ArrayList drums_hit = new ArrayList();
	for (int i = 0; i<drums.length; i++) {
		if (ds1.x-ds1.rad > drums[i].x+drums[i].width) {continue;}
		if (ds1.x+ds1.rad < drums[i].x) {continue;}
		if (ds1.y+ds1.rad < drums[i].y) {continue;}
		if (ds1.y-ds1.rad > drums[i].y+drums[i].height) {continue;}
		drums_hit.add(i);
	}

	return drums_hit;	
}

void highlight_drums(ArrayList drums_hit) {	
	for (int i = 0; i<drums_hit.size(); i++) {
		drums[drums_hit.get(i)].highlight = true;
	}	
}

void mouseMoved() {
	ds1.x = mouseX;
	ds1.y = mouseY;
}

class Note {
	float x,y,width,height;
	float red,green,blue;
	boolean exists = true;

	Note(float xp,float yp,float w,float h,float r,float g,float b) {
		x = xp;
		y = yp;
		width = w;
		height = h;
		red = r;
		green = g;
		blue = b;
		exists = true;
	}

	Note() {
		exists = false;
	}

	void reset() {		
		float seed = random(0,1);

		if (seed < 0.25) {
			x = OVER_DRUM_0;
			y = 0;
		}
		else if (seed < 0.50) {
			x = OVER_DRUM_1;
			y = 0;
		}
		else if (seed < 0.75) {
			x = OVER_DRUM_2;
			y = 0;
		}
		else {
			x = OVER_DRUM_3;
			y = 0;
		}
	}

	void update() {
		if (!exists) {return;}
		y += note_speed;
		if (y > canv_h) {
			reset();
		}
	}

	void draw() {
		if (!exists) {return;}

		fill(red,green,blue,150);
		rect(x,y,width,height);
	}
}

class Drum {
	float x,y,width,height;
	float red,green,blue;
	boolean highlight = false;

	Drum(float xp, float yp, float w, float h, float r, float g, float b) {
		x = xp;
		y = yp;
		width = w;
		height = h;
		red = r;
		green = g;
		blue = b;
	}

	void draw() {
		if (highlight) {
			strokeWeight(15);
			stroke(red,green,blue);
			highlight = false;
		}

		fill(red,green,blue);
		rect(x,y,width,height);
		noStroke();
	}
}

class DrumStick {
	float x,y,rad;
	float red,green,blue;

	DrumStick(float xp, float yp) {
		x = xp;
		y = yp;
		rad = 50;
		red = 204;
		green = 102;
		blue = 0;
	}

	void draw() {
		fill(red,green,blue,150);
		ellipse(x,y,rad,rad);
	}
}




















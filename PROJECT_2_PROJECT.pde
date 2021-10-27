int acceleration, yPos = 0;
boolean offSwitch = false, gameOngoing = false, startOfGame = true, enemy1 = false, enemy2 = false, doubleEnemys = false, beamCharge = true;
int gameTick = 0, tickInc = 1, score = 0, hp = 3, beamY, beamCount, enemy1Y, enemy2Y, enemy1X, enemy2X;
int background1X = 0, background2X = 2000, enemy1destroy = 0, enemy2destroy = 0;
PImage background1, background2, fulldown, slightdown, straight, slightup, fullup, fullbeam, halfbeam, lowbeam, bomb, bomb2, explode11, explode12, explode13, explode21, explode22, explode23, health3, health2, health1;

void setup() {
  size(1920, 1080);
  yPos = 540;
  background1 = loadImage("background1.png");
  background2 = loadImage("background2.png");
  fulldown = loadImage("fulldown.png");
  slightdown = loadImage("slightdown.png");
  straight = loadImage("straight.png");
  slightup = loadImage("slightup.png");
  fullup = loadImage("fullup.png");
  fullbeam = loadImage("fullbeam.png");
  halfbeam = loadImage("halfbeam.png");
  lowbeam = loadImage("lowbeam.png");
  bomb = loadImage("bomb.png");
  bomb2 = loadImage("bomb.png");
  explode11 = loadImage("explode1.png");
  explode12 = loadImage("explode2.png");
  explode13 = loadImage("explode3.png");
  explode21 = loadImage("explode1.png");
  explode22 = loadImage("explode2.png");
  explode23 = loadImage("explode3.png");
  health3 = loadImage("3health.png");
  health2 = loadImage("2health.png");
  health1 = loadImage("1health.png");
}

void draw() {
  if (gameOngoing) {
    background(255);
    image(background1, background1X, 0);
    image(background2, background2X, 0);
    background1X -= 1;
    background2X -= 1;
    fill(0);
    textSize(50);
    text("Score: " + score, 10, 40);
    if (background2X == 0) {
      background1X = 2000;
    }
    if (background1X == 0) {
      background2X = 2000;
    }
    if (score > 100 && score < 250) {
      tickInc = 2;
    }
    if (score >= 250) {
      doubleEnemys = true;
      tickInc = 3;
    }
    if (hp == 3) {
      image(health3, 1800, 18);  
    } else if (hp == 2) {
      image(health2, 1800, 18);
    } else {
      image(health1, 1800, 18);
    }
    beamY = yPos + 30;
    gameTick += tickInc;
    if (gameTick >= 500) {
      gameTick = 0;
      spawnEnemy();
    }
    if (offSwitch) {
      acceleration++;
      offSwitch = false;
    } else {
      offSwitch = true;
    }
    if (yPos <= 10 && acceleration < 0) {
      acceleration = 0;
    }
    yPos += acceleration;
    if (acceleration >= 5) {
      image(fulldown, 100, yPos);
      beamCharge = true;
    } else if (acceleration > 0 && acceleration < 5) {
      image(slightdown, 100, yPos);
    } else if (acceleration == 0) {
      image(straight, 100, yPos);
    } else if (acceleration < 0 && acceleration > -5) {
      image(slightup, 100, yPos);
    } else if (acceleration <= -5) {
      image(fullup, 100, yPos);
    }
    if (yPos >= 1080) {
      gameEnd();
    }
    if (enemy1) {
      image(bomb, enemy1X, enemy1Y);
      if (tickInc == 1) {
        enemy1X -= 10;
      } else if (tickInc == 2) {
        enemy1X -= 15;
      } else if (tickInc == 3) {
        enemy1X -= 20;
      }
      if (enemy1X < 110) {
        enemy1 = false;
        enemy1destroy = 9;
        hp--;
      }
    }
    if (enemy2) {
      image(bomb2, enemy2X, enemy2Y);
      if (tickInc == 1) {
        enemy2X -= 10;
      } else if (tickInc == 2) {
        enemy2X -= 15;
      } else if (tickInc == 3) {
        enemy2X -= 20;
      }
      if (enemy2X < 110) {
        enemy2 = false;
        enemy2destroy = 9;
        hp--;
      }
    }
    if (beamCount > 0) {
      beamCount--;
      if (beamCount > 8) {
        image(fullbeam, 200, beamY);
      } else if (beamCount > 3) {
        image(halfbeam, 200, beamY);
      } else {
        image(lowbeam, 200, beamY);
      }
      if (beamY + 32 < enemy1Y + 50 && beamY + 32 > enemy1Y && enemy1 || beamY < enemy1Y + 50 && beamY > enemy1Y && enemy1) {
        enemy1 = false;
        score += 10;
        enemy1destroy = 9;
      }
      if (beamY + 32 < enemy2Y + 50 && beamY + 32 > enemy2Y && enemy2 || beamY < enemy2Y + 50 && beamY > enemy2Y && enemy2) {
        enemy2 = false;
        score += 10;
        enemy2destroy = 9;
      }
    }
    if (hp <= 0) {
      gameOngoing = false;
      gameEnd();
    }
    enemyDestroyed();
  } else if (!gameOngoing && startOfGame) {
    background(102, 255, 255);
    fill(0);
    textSize(50);
    text("Press space to propel your craft (on the left side of the screen) upward!", 50, 75);
    text("If the lever is all the way up, a laser will fire out!", 50, 150);
    text("Use the laser to defeat enemies!", 50, 225);
    text("If an enemy reaches your side of the screen 3 times, you lose!", 50, 300);
    text("If you touch the bottom of the screen, you lose! Be careful!", 50, 375);
    text("The game will get more difficult as you go along! Good luck!", 50, 450);
    text("Press Space to start!", 50, 525);
  }
}

void keyPressed() {
  if (key == ' ') {
    if (gameOngoing) {
    acceleration = -15;
    if (beamCharge) {
      beamCharge = false;
      beamCount = 20;
    }
    } else {
      gameOngoing = true;
      startOfGame = false;
    }
  }
}

public void gameEnd() {
  gameOngoing = false;
  background(255, 100, 100);
  textSize(150);
  text("GAME OVER!", 500, 500);
  textSize(50);
  text("Score: " + score, 700, 575);
}

public void spawnEnemy() {
  enemy1Y = (int)random(100, 980);
  enemy1 = true;
  enemy1X = 1920;
  if (doubleEnemys) {
    enemy2Y = (int)random(100, 980);  
    enemy2 = true;
    enemy2X = 1920;
  }
}

public void enemyDestroyed() {
  if (gameOngoing) {
    if (enemy1destroy > 0) {
      if (enemy1destroy >= 6) {
        image(explode11, enemy1X, enemy1Y);
      } else if (enemy1destroy >= 3 && enemy1destroy < 6) {
        image(explode12, enemy1X, enemy1Y);
      } else {
        image(explode13, enemy1X, enemy1Y);
      }
      enemy1destroy--;
    }
    if (enemy2destroy > 0) {
      if (enemy2destroy >= 6) {
        image(explode21, enemy2X, enemy2Y);
      } else if (enemy1destroy >= 3 && enemy1destroy < 6) {
        image(explode22, enemy2X, enemy2Y);
      } else {
        image(explode23, enemy2X, enemy2Y);
      }
      enemy2destroy--;
    }
  }
}



$(document).ready(function () {
    'use strict';

   // Assign a variable to a jQuery element object
var $div = $(“div”);
// Animate the element using Velocity
$div.velocity({ opacity: 0 });
//This syntax is identical to jQuery’s own animate function:
$div.animate({ opacity: 0 });     
      
    paper.install(window);

    paper.setup(document.getElementById('mainCanvas'));

    var c;

    for (var x = 25; x < 400; x += 50) {
        for (var y = 25; y < 400; y += 50) {
            c = Shape.Circle(x, y, 20);
            c.fillColor = 'blue';
        }
    }

    var c = Shape.Circle(200, 200, 80);
    c.fillColor = 'white';
    var text = new PointText(200, 208);
    text.justification = 'center';
    text.fillColor = 'orange';
    text.fontSize = 25;
    text.content = 'Hello, World';

    paper.view.draw();

    paper.setup(document.getElementById('secondCanvas'));

    var tool = new Tool();

    tool.onMouseDown = function(event) {
            var c = Shape.Circle(event.point.x, event.point.y, 20);
            c.fillColor = 'green';
        
        console.log(event);
    };

    paper.view.draw();


});


$(document).ready(function () {
    'use strict';
 
});

    let timeVar = setInterval(runTimer, 1000);
    let intervalCount = 0;

    function runTimer() {
    //   var d = new Date();
    //   document.getElementById("demo").innerHTML = d.toLocaleTimeString();
      document.getElementById("timer").innerHTML = intervalCount;
      intervalCount = intervalCount + 1;
    }
    
    function displayDate(){
        this.innerHTML=Date();
        // document.getElementById("timer").innerHTML=Date();
    }
    // document.getElementById("code").innerHTML = "Hello World!";  
      

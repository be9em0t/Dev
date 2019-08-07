console.log("seems ok");

let startVar = 467;

userIn = prompt("give me a number", 42);

userIn = Number(userIn);

if (Number.isInteger(userIn)) alert("integer");
else if (Number.isNaN(userIn)) alert("nan");
else alert("blah");


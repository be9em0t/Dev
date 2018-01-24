using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesktopIcons
{

    class Person
    {
        public string FirstName { get; set; }
        public int Age { get; set; }
        public string FavColor { get; set; }

        public Person(string fName, int age, string color)
        {
            FirstName = fName;
            Age = age;
            FavColor = color;
        }

    }
}

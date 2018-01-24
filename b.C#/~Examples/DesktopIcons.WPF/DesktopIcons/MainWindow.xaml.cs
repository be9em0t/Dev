using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;


namespace DesktopIcons
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>

    public partial class MainWindow : Window
    {
        public string someText { get; set; }
        //public string someTextContent = "blah";


        public MainWindow()
        {
            //InitializeComponent();
            //this.DataContext = this;
            //Text = "test some";

            InitializeComponent();
            Binding myBinding = new Binding();
            myBinding.Source = TextBox1;
            myBinding.Path = new PropertyPath("Text");
            // Connect the Source and the Target.
            Label1.SetBinding(Label.ContentProperty, myBinding);
            LabelTwo.SetBinding(Label.ContentProperty, myBinding);
            LabelTwo.FontSize = 16;

            someText = "blah";
            Binding someBinding = new Binding();
            someBinding.Source = someText;
            Label3.SetBinding(Label.ContentProperty, someBinding);

            Person p = new Person("Shiely", 22, "red");
            Binding NameBinding = new Binding("FirstName");
            NameBinding.Source = p;
            lblFName.SetBinding(ContentProperty, NameBinding);
            Binding AgeBinding = new Binding("Age");
            AgeBinding.Source = p;
            lblAge.SetBinding(ContentProperty, AgeBinding);
            Binding ColorBinding = new Binding("FavColor");
            ColorBinding.Source = p;
            lblColor.SetBinding(ContentProperty, ColorBinding);

        }

    }
}



using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.Serialization;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Xml;
using System.Xml.XPath;
using BBC.Dna;
using BBC.Dna.Api;
using BBC.Dna.Component;
using BBC.Dna.Data;
using BBC.Dna.Moderation.Utils;
using BBC.Dna.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Tests;
using System.Collections.Specialized;
using BBC.Dna.Objects;

namespace FunctionalTests.Services.Articles
{
    /// <summary>
    /// Class containing the Comment Box Tests
    /// </summary>
    [TestClass]
    public class Article_V1
    {
        private const string _schemaArticle = "Dna.Services.Articles\\article.xsd";
        private string _server = DnaTestURLRequest.CurrentServer;
        private string _sitename = "h2g2";

        //private string _skinnedGuideML = @"<br /><p>A dialect found mostly in East <a href=""A6681062"">London</a>, where people obviously have more time to say what they want to say, and are more paranoid about being overheard. The principle is to decide what it is you want to say, and then find words which bear no real relation to what you're going to say, but which rhyme loosely with your phrase.</p><br /><br /><p>Sometimes the connection is totally obscure. For example, 'Bottle and Glass' (Arse) was obviously a bit racy, so it is put at one remove with 'Aristotle' = Bottle. This is then contracted again so that you say 'Aris', which is almost exactly what you started out trying not to say. Some secret language...</p><br /><br /><p>Cockney rhyming slang used to be a form of Pidgin English designed so that the working <a href=""A513596"">Eastenders</a> could have a right good chin wag without the toffs knowing that they were talking about them. These days people just make it up for a laugh, so young streetwise Londoners say things like 'Ah mate, 'ad a right mare I did, got chucked out me pad, blew me lump, and now fings wiv the trouble and strife have gone all pete tong!'</p><br /><br /><p>Here's our horribly incomplete list of popular Cockney rhyming slang. If you know any others, why not post them to the forum below?</p><br />CockneyMeaningExample<br />Adam and Eve<br />Believe<br />I don't bloody Adam and Eve it!<br /><br />Alan Whickers<br />Knickers<br />Okay, okay, keep yer Alans on! <br /><br />Apple Fritter<br />Bitter (beer)<br />They've got some new Apple at the Battle.<br /><br />Apples and Pears<br />Stairs<br />Get yer Bacons up the Apples and Pears. <br /><br />Aris<br />Arse<br />Nice Aris!<br /><br />Army and Navy <br />Gravy<br />Pass the Army, son.<br /><br />Artful Dodger<br />Lodger<br />I've got an Artful to help pay the rent. <br /><br />Ayrton Senna<br />Tenner (ten pound note)<br />You owe me an Ayrton. <br /><br />Bacon and Eggs<br />Legs<br />She's got a lovely set of Bacons. <br /><br />Bang Allan Border<br />Bang out of order<br />He's bang Allan (used when someone does something nasty to someone else).<br /><br />Barn Owl (Barney)<br />Row (argument)<br />'Ad a Barney with me Artful 'cos 'e refused to give me my Ayrton's. <br /><br />Barnet Fair<br />Hair<br />She's just got her Barnet chopped.<br /><br />Boat Race<br />Face<br />Smashed 'im in the Boat.<br /><br />Battle Cruiser<br />Boozer (off license)<br />I'm off to the Battle to get some Apple. <br /><br />Bottle and Glass<br />Arse<br />He fell on his Bottle.<br /><br />Brass bands<br />Hands<br />I shook him by the Brass.<br /><br />Bread and Honey<br />Money<br />He's got loads of Bread.<br /><br />Britney Spears<br />Beers<br />Give us a couple of Britney's will ya?<br /><br />Brown Bread<br />Dead<br />He's Brown Bread. <br /><br />Bubble Bath<br />Laugh<br />You're 'avin' a Bubble.<br /><br />Butcher's Hook<br />Look<br />Take a Butcher's at that!<br /><br />Chevy Chase<br />Face<br />He fell on 'is Chevy.<br /><br />China Plate<br />Mate<br />How are you, me old China?<br /><br />Christian Slater<br />Later<br />See ya Slater.<br /><br />Cream Crackered<br />Knackered (tired/broken)<br />I'm Cream Crackered! <br /><br />Currant Bun<br />Sun<br />The Currant Bun's hot today.<br /><br />Daisy Roots<br />Boots<br />'Ere, put on yer Daisies.<br /><br />Danny Marr <br />Car<br />I'll give you a lift in the Danny.<br /><br />David Gower<br />Shower<br />Give us half an hour mate I've gotta go for a David.<br /><br />Dicky Bird<br />Word<br />He hasn't said a Dicky in hours.<br /><br />Dog and Bone<br />Phone<br />She's always on the Dog.<br /><br />Donkey's Ears<br />Years<br />Ain't seen you in Donkeys.<br /><br />Drum'n'Bass<br />Face<br />Look me in the Drum.<br /><br />Dudley (Dudley Moore)<br />A score, or 20 pounds<br />Loan me a Dudley?<br /><br />Elephant's Ears<br />Beers<br />Get the Elephants in, mate!<br /><br />Frog &amp; Toad<br />Road<br />I was walking down the Frog...<br /><br />Ham'n'cheesy<br />Easy<br />Ham'n'cheesy does it.<br /><br />Hank Marvin<br />Starving (hungry)<br />I'm Hank Marvin.<br /><br />Jam Jar<br />Car<br />Me Jam Jar's Cream Crackered. <br /><br />Jimmy Riddle<br />Piddle (urinate)<br />I really need to go for a Jimmy. <br /><br />Joanna<br />Piano<br />He's great on the Joanna. <br /><br />Khyber Pass<br />Arse<br />He kicked him up the Khyber.<br /><br />Lady Godiva<br />Fiver (five pound note)<br />Lend us a Lady, mate.<br /><br />Lee Marvin<br />Starving<br />I'm bloody Lee Marvin mate.<br /><br />Lemon Squeezy<br />Easy<br />It was Lemon, mate.<br /><br />Lionel Blairs<br />Flares<br />Look at the Lionels on 'im.<br /><br />Loaf of Bread<br />Head<br />That's using the old Loaf.<br /><br />Mince Pies<br />Eyes<br />You've got lovely Mince Pies my dear.<br /><br />Mork and Mindy<br />Windy<br />It's a little bit Mork and Mindy today, innit?<br /><br />Mother Hubbard<br />Cupboard<br />There's no grub in the Mother. <br /><br />Nanny Goat<br />Coat<br />How much for the Nanny?<br /><br />Nelson Mandela<br />Stella (Artois)<br />Mine's a pint of Nelson!<br /><br />Nuclear Sub<br />Pub<br />Fancy a quick one down the Nuclear?<br /><br />Oily Rag<br />Fag (cigarette)<br />Gis' an Oily, mate.<br /><br />Pen and Ink<br />Stink<br />Eurgh! That Pen and Ink's!<br /><br />Pete Tong<br />Wrong<br />Everything?s gone Pete Tong.<br /><br />Pinch (steal)<br />Half Inch<br />Someone's half-inched me Ayrton. <br /><br />Plate of Meat<br />Street<br />I was walking down the Plate...<br /><br />Plates of Meat<br />Feet<br />I've been on me Plates all day.<br /><br />Pony<br />£25<br />Lend me a Pony?<br /><br />Pony and Trap<br />Crap<br />This game's a bit Pony.<br /><br />Pork Pies (Porkie Pies)<br />Lies<br />He's always telling Porkies. <br /><br />Queen Mum<br />Bum<br />Get off your Queen Mum.<br /><br />Rabbit &amp; Pork<br />Talk<br />She Rabbits on a bit.<br /><br />Raspberry Tart<br />Fart<br />That Raspberry bloody Pen and Inks. <br /><br />Richard the Third<br />Turd<br />That bloke's a complete Richard. <br /><br />Rosie Lee<br />Tea<br />If you're brewing a pot, I'll have a Rosie.<br /><br />Round The Houses<br />Trousers<br />Take a Butcher's at those Rounds!<br /><br />Ruby Murray<br />Curry<br />I'm going for a Ruby.<br /><br />Saucepan Lid<br />Kid<br />He's only gone and had a Saucepan.<br /><br />Septic Tank<br />Yank<br />Well, 'es a bloody Septic, inni?<br /><br />Sky Rocket<br />Pocket<br />Me Skies are empty. <br /><br />Steam Tug<br />Do something stupid (Steam tug = Mug = Fool)<br />He went steaming ahead and did it anyway.<br /><br />Stoke-on-Trent<br />Bent (criminal)<br />He's totally Stoke.<br /><br />Sweeney Todd<br />Flying Squad (Police)<br />Here come the Sweeney. <br /><br />Syrup of Figs<br />Wig<br />Check out the Syrup on 'is head.<br /><br />Tea Leaf<br />Thief<br />Watch it, he's a bloody Tea Leaf.<br /><br />Tit for tat<br />Hat<br />Has anyone seen my Titfer?<br /><br />Tom and Dick<br />Sick<br />He?s feeling a bit Tom. <br /><br />Tom Foolery<br />Jewellery<br />I gave me Trouble some Tom Foolery for Christmas.<br /><br />Trouble and Strife<br />Wife<br />Just had a Barney with me Trouble. <br /><br />Two and Eight<br />State (of anguish)<br />He's in a right old Two and Eight. <br /><br />Uncle Dick<br />Sick<br />He's just been Uncle Dick over me new Whistle. <br /><br />Vera Lynns<br />Skins (tobacco paper)<br />Pass the Veras, mate, and I'll roll up.<br /><br />Weasel &amp; Stoat<br />Coat<br />Pull on yer Weasel.<br /><br />Whistle and Flute<br />Suit<br />I just got a new Whistle. <br /><br /><br />";
        //private string _AerianSkinnedGuideML = @"<br /><p>A dialect found mostly in East <a href=""/h2g2/beta/entry/A6681062"">London</a>, where people obviously have more time to say what they want to say, and are more paranoid about being overheard. The principle is to decide what it is you want to say, and then find words which bear no real relation to what you're going to say, but which rhyme loosely with your phrase.</p><br /><br /><p>Sometimes the connection is totally obscure. For example, 'Bottle and Glass' (Arse) was obviously a bit racy, so it is put at one remove with 'Aristotle' = Bottle. This is then contracted again so that you say 'Aris', which is almost exactly what you started out trying not to say. Some secret language...</p><br /><br /><p>Cockney rhyming slang used to be a form of Pidgin English designed so that the working <a href=""/h2g2/beta/entry/A513596"">Eastenders</a> could have a right good chin wag without the toffs knowing that they were talking about them. These days people just make it up for a laugh, so young streetwise Londoners say things like 'Ah mate, 'ad a right mare I did, got chucked out me pad, blew me lump, and now fings wiv the trouble and strife have gone all pete tong!'</p><br /><br /><p>Here's our horribly incomplete list of popular Cockney rhyming slang. If you know any others, why not post them to the forum below?</p><br />CockneyMeaningExample<br />Adam and Eve<br />Believe<br />I don't bloody Adam and Eve it!<br /><br />Alan Whickers<br />Knickers<br />Okay, okay, keep yer Alans on! <br /><br />Apple Fritter<br />Bitter (beer)<br />They've got some new Apple at the Battle.<br /><br />Apples and Pears<br />Stairs<br />Get yer Bacons up the Apples and Pears. <br /><br />Aris<br />Arse<br />Nice Aris!<br /><br />Army and Navy <br />Gravy<br />Pass the Army, son.<br /><br />Artful Dodger<br />Lodger<br />I've got an Artful to help pay the rent. <br /><br />Ayrton Senna<br />Tenner (ten pound note)<br />You owe me an Ayrton. <br /><br />Bacon and Eggs<br />Legs<br />She's got a lovely set of Bacons. <br /><br />Bang Allan Border<br />Bang out of order<br />He's bang Allan (used when someone does something nasty to someone else).<br /><br />Barn Owl (Barney)<br />Row (argument)<br />'Ad a Barney with me Artful 'cos 'e refused to give me my Ayrton's. <br /><br />Barnet Fair<br />Hair<br />She's just got her Barnet chopped.<br /><br />Boat Race<br />Face<br />Smashed 'im in the Boat.<br /><br />Battle Cruiser<br />Boozer (off license)<br />I'm off to the Battle to get some Apple. <br /><br />Bottle and Glass<br />Arse<br />He fell on his Bottle.<br /><br />Brass bands<br />Hands<br />I shook him by the Brass.<br /><br />Bread and Honey<br />Money<br />He's got loads of Bread.<br /><br />Britney Spears<br />Beers<br />Give us a couple of Britney's will ya?<br /><br />Brown Bread<br />Dead<br />He's Brown Bread. <br /><br />Bubble Bath<br />Laugh<br />You're 'avin' a Bubble.<br /><br />Butcher's Hook<br />Look<br />Take a Butcher's at that!<br /><br />Chevy Chase<br />Face<br />He fell on 'is Chevy.<br /><br />China Plate<br />Mate<br />How are you, me old China?<br /><br />Christian Slater<br />Later<br />See ya Slater.<br /><br />Cream Crackered<br />Knackered (tired/broken)<br />I'm Cream Crackered! <br /><br />Currant Bun<br />Sun<br />The Currant Bun's hot today.<br /><br />Daisy Roots<br />Boots<br />'Ere, put on yer Daisies.<br /><br />Danny Marr <br />Car<br />I'll give you a lift in the Danny.<br /><br />David Gower<br />Shower<br />Give us half an hour mate I've gotta go for a David.<br /><br />Dicky Bird<br />Word<br />He hasn't said a Dicky in hours.<br /><br />Dog and Bone<br />Phone<br />She's always on the Dog.<br /><br />Donkey's Ears<br />Years<br />Ain't seen you in Donkeys.<br /><br />Drum'n'Bass<br />Face<br />Look me in the Drum.<br /><br />Dudley (Dudley Moore)<br />A score, or 20 pounds<br />Loan me a Dudley?<br /><br />Elephant's Ears<br />Beers<br />Get the Elephants in, mate!<br /><br />Frog &amp; Toad<br />Road<br />I was walking down the Frog...<br /><br />Ham'n'cheesy<br />Easy<br />Ham'n'cheesy does it.<br /><br />Hank Marvin<br />Starving (hungry)<br />I'm Hank Marvin.<br /><br />Jam Jar<br />Car<br />Me Jam Jar's Cream Crackered. <br /><br />Jimmy Riddle<br />Piddle (urinate)<br />I really need to go for a Jimmy. <br /><br />Joanna<br />Piano<br />He's great on the Joanna. <br /><br />Khyber Pass<br />Arse<br />He kicked him up the Khyber.<br /><br />Lady Godiva<br />Fiver (five pound note)<br />Lend us a Lady, mate.<br /><br />Lee Marvin<br />Starving<br />I'm bloody Lee Marvin mate.<br /><br />Lemon Squeezy<br />Easy<br />It was Lemon, mate.<br /><br />Lionel Blairs<br />Flares<br />Look at the Lionels on 'im.<br /><br />Loaf of Bread<br />Head<br />That's using the old Loaf.<br /><br />Mince Pies<br />Eyes<br />You've got lovely Mince Pies my dear.<br /><br />Mork and Mindy<br />Windy<br />It's a little bit Mork and Mindy today, innit?<br /><br />Mother Hubbard<br />Cupboard<br />There's no grub in the Mother. <br /><br />Nanny Goat<br />Coat<br />How much for the Nanny?<br /><br />Nelson Mandela<br />Stella (Artois)<br />Mine's a pint of Nelson!<br /><br />Nuclear Sub<br />Pub<br />Fancy a quick one down the Nuclear?<br /><br />Oily Rag<br />Fag (cigarette)<br />Gis' an Oily, mate.<br /><br />Pen and Ink<br />Stink<br />Eurgh! That Pen and Ink's!<br /><br />Pete Tong<br />Wrong<br />Everything?s gone Pete Tong.<br /><br />Pinch (steal)<br />Half Inch<br />Someone's half-inched me Ayrton. <br /><br />Plate of Meat<br />Street<br />I was walking down the Plate...<br /><br />Plates of Meat<br />Feet<br />I've been on me Plates all day.<br /><br />Pony<br />£25<br />Lend me a Pony?<br /><br />Pony and Trap<br />Crap<br />This game's a bit Pony.<br /><br />Pork Pies (Porkie Pies)<br />Lies<br />He's always telling Porkies. <br /><br />Queen Mum<br />Bum<br />Get off your Queen Mum.<br /><br />Rabbit &amp; Pork<br />Talk<br />She Rabbits on a bit.<br /><br />Raspberry Tart<br />Fart<br />That Raspberry bloody Pen and Inks. <br /><br />Richard the Third<br />Turd<br />That bloke's a complete Richard. <br /><br />Rosie Lee<br />Tea<br />If you're brewing a pot, I'll have a Rosie.<br /><br />Round The Houses<br />Trousers<br />Take a Butcher's at those Rounds!<br /><br />Ruby Murray<br />Curry<br />I'm going for a Ruby.<br /><br />Saucepan Lid<br />Kid<br />He's only gone and had a Saucepan.<br /><br />Septic Tank<br />Yank<br />Well, 'es a bloody Septic, inni?<br /><br />Sky Rocket<br />Pocket<br />Me Skies are empty. <br /><br />Steam Tug<br />Do something stupid (Steam tug = Mug = Fool)<br />He went steaming ahead and did it anyway.<br /><br />Stoke-on-Trent<br />Bent (criminal)<br />He's totally Stoke.<br /><br />Sweeney Todd<br />Flying Squad (Police)<br />Here come the Sweeney. <br /><br />Syrup of Figs<br />Wig<br />Check out the Syrup on 'is head.<br /><br />Tea Leaf<br />Thief<br />Watch it, he's a bloody Tea Leaf.<br /><br />Tit for tat<br />Hat<br />Has anyone seen my Titfer?<br /><br />Tom and Dick<br />Sick<br />He?s feeling a bit Tom. <br /><br />Tom Foolery<br />Jewellery<br />I gave me Trouble some Tom Foolery for Christmas.<br /><br />Trouble and Strife<br />Wife<br />Just had a Barney with me Trouble. <br /><br />Two and Eight<br />State (of anguish)<br />He's in a right old Two and Eight. <br /><br />Uncle Dick<br />Sick<br />He's just been Uncle Dick over me new Whistle. <br /><br />Vera Lynns<br />Skins (tobacco paper)<br />Pass the Veras, mate, and I'll roll up.<br /><br />Weasel &amp; Stoat<br />Coat<br />Pull on yer Weasel.<br /><br />Whistle and Flute<br />Suit<br />I just got a new Whistle. <br /><br /><br />";

        private string _AerianSkinnedGuideML = @"<img src=""http://www.bbc.co.uk/dna/h2g2/brunel/B62338white.gif"" alt=""A dog and bone, and a phone"" title=""A dog and bone, and a phone"" class=""Right"" /><p>A dialect found mostly in East <a href=""/h2g2/beta/entry/A6681062"">London</a>, where people obviously have more time to say what they want to say, and are more paranoid about being overheard. The principle is to decide what it is you want to say, and then find words which bear no real relation to what you're going to say, but which rhyme loosely with your phrase.</p><p>Sometimes the connection is totally obscure. For example, 'Bottle and Glass' (Arse) was obviously a bit racy, so it is put at one remove with 'Aristotle' = Bottle. This is then contracted again so that you say 'Aris', which is almost exactly what you started out trying not to say. Some secret language...</p><p>Cockney rhyming slang used to be a form of Pidgin English designed so that the working <a href=""/h2g2/beta/entry/A513596"">Eastenders</a> could have a right good chin wag without the toffs knowing that they were talking about them. These days people just make it up for a laugh, so young streetwise Londoners say things like 'Ah mate, 'ad a right mare I did, got chucked out me pad, blew me lump, and now fings wiv the trouble and strife have gone all pete tong!'</p><p>Here's our horribly incomplete list of popular Cockney rhyming slang. If you know any others, why not post them to the forum below?</p><table><tr><th>Cockney</th><th>Meaning</th><th>Example</th></tr><tr><td>Adam and Eve</td><td>Believe</td><td>I don't bloody Adam and Eve it!</td></tr><tr><td>Alan Whickers</td><td>Knickers</td><td>Okay, okay, keep yer Alans on! </td></tr><tr><td>Apple Fritter</td><td>Bitter (beer)</td><td>They've got some new Apple at the Battle.</td></tr><tr><td>Apples and Pears</td><td>Stairs</td><td>Get yer Bacons up the Apples and Pears. </td></tr><tr><td>Aris</td><td>Arse</td><td>Nice Aris!</td></tr><tr><td>Army and Navy </td><td>Gravy</td><td>Pass the Army, son.</td></tr><tr><td>Artful Dodger</td><td>Lodger</td><td>I've got an Artful to help pay the rent. </td></tr><tr><td>Ayrton Senna</td><td>Tenner (ten pound note)</td><td>You owe me an Ayrton. </td></tr><tr><td>Bacon and Eggs</td><td>Legs</td><td>She's got a lovely set of Bacons. </td></tr><tr><td>Bang Allan Border</td><td>Bang out of order</td><td>He's bang Allan (used when someone does something nasty to someone else).</td></tr><tr><td>Barn Owl (Barney)</td><td>Row (argument)</td><td>'Ad a Barney with me Artful 'cos 'e refused to give me my Ayrton's. </td></tr><tr><td>Barnet Fair</td><td>Hair</td><td>She's just got her Barnet chopped.</td></tr><tr><td>Boat Race</td><td>Face</td><td>Smashed 'im in the Boat.</td></tr><tr><td>Battle Cruiser</td><td>Boozer (off license)</td><td>I'm off to the Battle to get some Apple. </td></tr><tr><td>Bottle and Glass</td><td>Arse</td><td>He fell on his Bottle.</td></tr><tr><td>Brass bands</td><td>Hands</td><td>I shook him by the Brass.</td></tr><tr><td>Bread and Honey</td><td>Money</td><td>He's got loads of Bread.</td></tr><tr><td>Britney Spears</td><td>Beers</td><td>Give us a couple of Britney's will ya?</td></tr><tr><td>Brown Bread</td><td>Dead</td><td>He's Brown Bread. </td></tr><tr><td>Bubble Bath</td><td>Laugh</td><td>You're 'avin' a Bubble.</td></tr><tr><td>Butcher's Hook</td><td>Look</td><td>Take a Butcher's at that!</td></tr><tr><td>Chevy Chase</td><td>Face</td><td>He fell on 'is Chevy.</td></tr><tr><td>China Plate</td><td>Mate</td><td>How are you, me old China?</td></tr><tr><td>Christian Slater</td><td>Later</td><td>See ya Slater.</td></tr><tr><td>Cream Crackered</td><td>Knackered (tired/broken)</td><td>I'm Cream Crackered! </td></tr><tr><td>Currant Bun</td><td>Sun</td><td>The Currant Bun's hot today.</td></tr><tr><td>Daisy Roots</td><td>Boots</td><td>'Ere, put on yer Daisies.</td></tr><tr><td>Danny Marr </td><td>Car</td><td>I'll give you a lift in the Danny.</td></tr><tr><td>David Gower</td><td>Shower</td><td>Give us half an hour mate I've gotta go for a David.</td></tr><tr><td>Dicky Bird</td><td>Word</td><td>He hasn't said a Dicky in hours.</td></tr><tr><td>Dog and Bone</td><td>Phone</td><td>She's always on the Dog.</td></tr><tr><td>Donkey's Ears</td><td>Years</td><td>Ain't seen you in Donkeys.</td></tr><tr><td>Drum'n'Bass</td><td>Face</td><td>Look me in the Drum.</td></tr><tr><td>Dudley (Dudley Moore)</td><td>A score, or 20 pounds</td><td>Loan me a Dudley?</td></tr><tr><td>Elephant's Ears</td><td>Beers</td><td>Get the Elephants in, mate!</td></tr><tr><td>Frog &amp; Toad</td><td>Road</td><td>I was walking down the Frog...</td></tr><tr><td>Ham'n'cheesy</td><td>Easy</td><td>Ham'n'cheesy does it.</td></tr><tr><td>Hank Marvin</td><td>Starving (hungry)</td><td>I'm Hank Marvin.</td></tr><tr><td>Jam Jar</td><td>Car</td><td>Me Jam Jar's Cream Crackered. </td></tr><tr><td>Jimmy Riddle</td><td>Piddle (urinate)</td><td>I really need to go for a Jimmy. </td></tr><tr><td>Joanna</td><td>Piano</td><td>He's great on the Joanna. </td></tr><tr><td>Khyber Pass</td><td>Arse</td><td>He kicked him up the Khyber.</td></tr><tr><td>Lady Godiva</td><td>Fiver (five pound note)</td><td>Lend us a Lady, mate.</td></tr><tr><td>Lee Marvin</td><td>Starving</td><td>I'm bloody Lee Marvin mate.</td></tr><tr><td>Lemon Squeezy</td><td>Easy</td><td>It was Lemon, mate.</td></tr><tr><td>Lionel Blairs</td><td>Flares</td><td>Look at the Lionels on 'im.</td></tr><tr><td>Loaf of Bread</td><td>Head</td><td>That's using the old Loaf.</td></tr><tr><td>Mince Pies</td><td>Eyes</td><td>You've got lovely Mince Pies my dear.</td></tr><tr><td>Mork and Mindy</td><td>Windy</td><td>It's a little bit Mork and Mindy today, innit?</td></tr><tr><td>Mother Hubbard</td><td>Cupboard</td><td>There's no grub in the Mother. </td></tr><tr><td>Nanny Goat</td><td>Coat</td><td>How much for the Nanny?</td></tr><tr><td>Nelson Mandela</td><td>Stella (Artois)</td><td>Mine's a pint of Nelson!</td></tr><tr><td>Nuclear Sub</td><td>Pub</td><td>Fancy a quick one down the Nuclear?</td></tr><tr><td>Oily Rag</td><td>Fag (cigarette)</td><td>Gis' an Oily, mate.</td></tr><tr><td>Pen and Ink</td><td>Stink</td><td>Eurgh! That Pen and Ink's!</td></tr><tr><td>Pete Tong</td><td>Wrong</td><td>Everything?s gone Pete Tong.</td></tr><tr><td>Pinch (steal)</td><td>Half Inch</td><td>Someone's half-inched me Ayrton. </td></tr><tr><td>Plate of Meat</td><td>Street</td><td>I was walking down the Plate...</td></tr><tr><td>Plates of Meat</td><td>Feet</td><td>I've been on me Plates all day.</td></tr><tr><td>Pony</td><td>£25</td><td>Lend me a Pony?</td></tr><tr><td>Pony and Trap</td><td>Crap</td><td>This game's a bit Pony.</td></tr><tr><td>Pork Pies (Porkie Pies)</td><td>Lies</td><td>He's always telling Porkies. </td></tr><tr><td>Queen Mum</td><td>Bum</td><td>Get off your Queen Mum.</td></tr><tr><td>Rabbit &amp; Pork</td><td>Talk</td><td>She Rabbits on a bit.</td></tr><tr><td>Raspberry Tart</td><td>Fart</td><td>That Raspberry bloody Pen and Inks. </td></tr><tr><td>Richard the Third</td><td>Turd</td><td>That bloke's a complete Richard. </td></tr><tr><td>Rosie Lee</td><td>Tea</td><td>If you're brewing a pot, I'll have a Rosie.</td></tr><tr><td>Round The Houses</td><td>Trousers</td><td>Take a Butcher's at those Rounds!</td></tr><tr><td>Ruby Murray</td><td>Curry</td><td>I'm going for a Ruby.</td></tr><tr><td>Saucepan Lid</td><td>Kid</td><td>He's only gone and had a Saucepan.</td></tr><tr><td>Septic Tank</td><td>Yank</td><td>Well, 'es a bloody Septic, inni?</td></tr><tr><td>Sky Rocket</td><td>Pocket</td><td>Me Skies are empty. </td></tr><tr><td>Steam Tug</td><td>Do something stupid (Steam tug = Mug = Fool)</td><td>He went steaming ahead and did it anyway.</td></tr><tr><td>Stoke-on-Trent</td><td>Bent (criminal)</td><td>He's totally Stoke.</td></tr><tr><td>Sweeney Todd</td><td>Flying Squad (Police)</td><td>Here come the Sweeney. </td></tr><tr><td>Syrup of Figs</td><td>Wig</td><td>Check out the Syrup on 'is head.</td></tr><tr><td>Tea Leaf</td><td>Thief</td><td>Watch it, he's a bloody Tea Leaf.</td></tr><tr><td>Tit for tat</td><td>Hat</td><td>Has anyone seen my Titfer?</td></tr><tr><td>Tom and Dick</td><td>Sick</td><td>He?s feeling a bit Tom. </td></tr><tr><td>Tom Foolery</td><td>Jewellery</td><td>I gave me Trouble some Tom Foolery for Christmas.</td></tr><tr><td>Trouble and Strife</td><td>Wife</td><td>Just had a Barney with me Trouble. </td></tr><tr><td>Two and Eight</td><td>State (of anguish)</td><td>He's in a right old Two and Eight. </td></tr><tr><td>Uncle Dick</td><td>Sick</td><td>He's just been Uncle Dick over me new Whistle. </td></tr><tr><td>Vera Lynns</td><td>Skins (tobacco paper)</td><td>Pass the Veras, mate, and I'll roll up.</td></tr><tr><td>Weasel &amp; Stoat</td><td>Coat</td><td>Pull on yer Weasel.</td></tr><tr><td>Whistle and Flute</td><td>Suit</td><td>I just got a new Whistle. </td></tr></table>";
        
        private string _unskinnedGuideML = @"<PICTURE embed=""Right"" shadow=""None"" H2G2IMG=""towerbridge.jpg"" ALT=""London's Tower Bridge, in silhouette."" /><P>Tower Bridge, widely regarded as the most glamorous bridge across the Thames, was built because the demand for access across the Thames in <LINK H2G2=""A6681062"">London</LINK> far exceeded the capacity of the existing bridges. Increased commercial activity in the East End was creating a need for more vehicles to be able to cross the river, downstream of London Bridge. </P><P>Sheer weight of traffic was causing huge problems, and over a period of 11 years around 30 petitions from public bodies were brought before the authorities. The most common suggestions were the building of a new bridge or the widening of London Bridge, although there was also a proposal for a railway line to be built at the bottom of the river. This would carry a travelling stage with its deck at high water level. Designing a bridge over a busy river with low banks was not going to be an easy task. The reason for the difficulties was that the 'pool' of London (the area between London Bridge and the Tower of London) was heavily used by river traffic, and access had to be maintained. </P><P>The pool has been heavily used since Roman times, because it meant that large ocean-going vessels could simply sail straight up the River Thames and unload their goods directly in the city; there was no need to transfer cargo to small river vessels. The river was a major transport route, and for centuries large ships docked at the wharves here to unload. This allowed their cargo to be distributed using the inland river system, and later, by Victorian canals. Although trade began moving away from the pool around the middle of the 20th Century, at the time, large vessels still needed constant access to the Pool.</P><P>In August 1882 the traffic over London Bridge was counted for two days to work out an average for a 24-hour period. At that time London Bridge was only 54 feet wide, yet was carrying over 22,000 vehicles and over 110,000 pedestrians. A committee was set up to consider the petitions and make a decision. Subways and large paddle ferries were also considered at this time. </P><HEADER>Decision-making and Design</HEADER><P>In 1878 the City architect Horace Jones proposed a bascule bridge. 'Bascule' comes from the French for 'see-saw', and a bascule bridge at street-level has two 'leaves' that can be raised on a horizontal axis to let ships pass on the river. Similar to a drawbridge, it works on a pivot with a heavy weight at one end to balance the length (weighing 1000 tons) at the other end. It would mean that steep approaches to the bridge could be avoided. His first design was rejected, but in 1884 his second was approved, and an Act of Parliament was passed in 1885 authorising its building. The Act stipulated an opening central span of 200 feet and headroom of 135 feet when the bridge was open<FOOTNOTE INDEX=""1"">The closed headroom was 29 feet to cater for the high tide, which could be 25 feet higher than low tide.</FOOTNOTE>. In practice these measurements were exceeded by five feet and six inches respectively. It was to be built in keeping with its surroundings - the Tower of London. The site was chosen because, in an area surrounded by wharves, it was cheaper to build the north side of the crossing in the Tower's ditch than it would have been to buy the land.</P><P>Horace Jones was appointed architect. His original designs were very medieval in influence, with the bascules being raised by chains. The revised design was been jointly presented with John Wolfe-Barry, a civil engineer, and was more influenced by the Victorian Gothic style, possibly because Wolfe-Barry's father had been one of the architects on the Houses of Parliament. The bridge's main towers are similar to those of a medieval Scottish castle and the bascules open like an old castle drawbridge. Many of the decorative elements on the stone façade, and the cast iron work are typical of Victorian Gothic architecture. </P><P>Horace Jones died in 1887, just over a year after building work had begun. The foundations had not been completed, and the architectural designs were still only sketches. His assistant George Stevenson took over, and changed the stonework from red brick to Portland stone and Cornish granite. Stevenson also designed many of the decorative details.</P><P>The bridge was opened to traffic by the Prince of Wales (the future King Edward VII) on 30 June, 1894, on behalf of Queen Victoria. The bridge had required eight years of construction at a cost of just over £1,000,000. The journal <I>The Builder</I> called the bridge '<I>the most monstrous and preposterous architectural sham that we have ever known</I>'.</P><HEADER>Construction</HEADER><P>Work was started on the bridge in 1886, with the Prince of Wales laying the foundation stone over a time capsule containing papers and coins. The work was intended to take only three years, but parliament was asked twice for more time. Two piers containing 70,000 tons of concrete were sunk into the river bed to support the weight of the bridge, and it was on these that the towers were built. Because the central area of the river could not be obstructed, the towers were built one at a time. The bascules had to be built in the upright position, including the wood paving.</P><P>The towers are 293 feet tall from the foundations, and are made of a steel frame to support the great weight of the bascules, clothed in stone to fit the stipulation that the bridge harmonised with the Tower of London. They contain lifts and stairs to the two walkways running between the towers. The walkways are 110 feet above the roadway and are held in place by metal girders. They were used to stabilise the bridge, and to give pedestrians a way to cross so that they did not have to wait for the bridge to be lowered before they could cross the Thames. As boats used sails less, and steam more, the bridge took only six minutes to open and close. Most pedestrians simply enjoyed the view while waiting for the bridge to close again. The walkways were closed in 1910 due to lack of use by most pedestrians - they had become home to prostitutes. They stayed closed to the public for over 70 years, although they did house some anti-aircraft guns during World War I, and have since been refurbished and re-opened as part of the visitor attractions for the bridge.</P><P>The two side-spans operate on the suspension principle; the 270-foot long approaches (decks) are hung from curved lattice girders. The girders are attached to the towers at the level of the walkway where they are linked together by a chain - each side anchoring the other. They curve down towards the road, then curve up again, reaching up and over the abutment towers at the shoreline before curving back down to the shore where they are anchored. Each chain that runs between the girders and the bridge weighs about the same as a small elephant, per metre.</P><P>The road has a width of 35 feet, with a 12.5-feet-wide pavement on either side; this makes the bridge 60 feet wide.</P><P>More detailed, technical information about the construction of the bridge can be found <LINK HREF=""http://www.hartwell.demon.co.uk/tbpic.htm"" TITLE=""Tower Bridge, London"">here</LINK>. Despite its appearance, Tower Bridge is a steel bridge, not stone, and is extremely strong. It was originally painted in a chocolate brown colour.</P><HEADER>Moving the Bascules</HEADER><P>The bridge has always been operated by hydraulics; originally the two pumping engines were powered by steam engines, and the energy stored in six accumulators, ready for use when needed. One set of engines powered the lifting engines which worked the pistons, cranks and cogs that raised the bridge, to save wear and tear. It lifted in less than one minute to 86 degrees. The south side opened slightly before the north side, as they were controlled seperately. Since 1976 the hydraulics have been powered by oil and electricity, and the bascules now open together.</P><P>When the bridge is shut, and the leaves brought together, two bolts called the 'nose bolts,' carried on each leaf, are locked by hydraulic power into sockets on the other leaf.</P><P>When the bridge needs to rise (this requires 24 hours notice), traffic lights stop the traffic. The road gates close, then the pedestrian gates close. The nose bolts are withdrawn, and the bridge lifts. The bascules only fully open for large ships, or to greet ships of importance. In their first year the bascules were raised 6160 times. Nowadays the bridge lifts around 1000 times a year to allow tall ships, cruise ships, naval vessels and other large craft to pass under, and can open and close in five minutes. The record amount of activity stands at 64 lifts in 24 hours in 1910. </P><HEADER>Action and Adventure</HEADER><P>The bridge has been the backdrop for a few exciting events, and has appeared in a number of films. These include <LINK H2G2=""A636923"">Bridget Jones's Diary</LINK>, The Mummy II, Spice World<FOOTNOTE INDEX=""2"">Where the <LINK H2G2=""A467750"">Spice Girls</LINK> jumped across the bridge as it opened in a double decker bus.</FOOTNOTE> and <LINK HREF=""http://www.imdb.com/title/tt0143145/"">The World is Not Enough</LINK>.</P><P>During the summer of 1912 the English pilot Frank McClean flew a short pusher biplane up the Thames. He failed to get sufficient height to clear the bridge, so he flew under the walkways. This event was captured by newspaper photographers, and the image became famous. He was not the only one - pilots (deliberately) flew under the walkways in 1973 and in 1978.</P><P>In 1952, a number 78 double-decker bus was unlucky enough to be on the bridge when it opened. Back then, the lights would change to red, the gateman would ring bells to encourage the pedestrians to move off the bridge quickly and close the gates, and the head watchman would order the bridge to lift when it was clear. On this day in December, there was a relief watchman, and something went wrong. Albert Gunton, the driver, saw that the road ahead appeared to be sinking. In fact, his bus was perched on the end of an opening bascule, which was giving the illusion of a sinking road ahead. He realised that he would not be able to stop in time to prevent going into the water, and making a split second decision, decided he would go for it. He accelerated and jumped the three feet gap, landing on the north bascule, which had not started to rise. None of his dozen passengers were seriously hurt, and he received £10 for his bravery. He also appeared later on '<LINK HREF=""http://www.whirligig-tv.co.uk/tv/adults/quiz/whatsmyline.htm"">What's My Line?</LINK>'</P><HEADER>Tower Bridge Exhibition</HEADER><P>The exhibition has been running for over 20 years, after a £2.5million conversion to the bridge to allow visits to the walkways and Victorian engine rooms, and to set the exhibition up. Visitors can learn about the history of the bridge and how it was built, visit the walkways and level three of the North Tower, and visit the Victorian engine rooms.</P><SUBHEADER>How to Get There</SUBHEADER><P>The nearest underground stations are Tower Hill and London Bridge. By rail it can be reached from London Bridge, Fenchurch Street and Tower Gateway on the Docklands Light Railway. </P><HEADER>Fascinating Facts</HEADER><UL><LI><P> An account of the bridge written in 1937 tells of a tugboat that stood at anchor, but with steam up and ready to go. The tug was there to go to the assistance of any vessel that was in difficulties and threatening the bridge, and to direct river traffic. The cost of maintenance for the tug was one of the conditions given for the erection of the bridge. In the 40 years it had been open at the time, the tug had hardly been used. In 1944 it was sunk by a V1 rocket which had bounced off the bridge. Unsurprisingly, a replacement was not deemed worthwhile. </P></LI><LI><P>Tower Bridge was the only bridge downstream of London Bridge until 1991, when the <LINK H2G2=""A667839"" TITLE=""The Thames River Crossings at Dartford"">Queen Elizabeth II</LINK> was built at Dartford. It was the last bridge built across the Thames in London before the Millennium Bridge opened, nearly 106 years to the day later<FOOTNOTE INDEX=""3"">The Millennium Bridge only stayed open for three days before closing for 20 months to stop a worrying 'sway'.</FOOTNOTE>. </P></LI><LI><P>Tower Bridge is the only moveable bridge on the River Thames, and is funded by an ancient trust - <LINK HREF=""http://www.bridgehousegrants.org.uk/history.htm"">Bridge House Estates</LINK> - which had been set up to manage London Bridge in the 11th Century. The trust keeps the bridge toll-free for road and river traffic, and is managed by the <LINK H2G2=""A642944"">Corporation of London</LINK>, who own and manage it. It is insured by Lloyd's of London on the shipping register as a ship, and for the first 23 years of its life, all staff were ex-sailors and servicemen.</P></LI><LI><P>Try standing in the middle of the bridge (on the pavement of course!) with one foot on each leaf. Wait for a bus or lorry to pass. Enjoy!</P></LI></UL>";

        private string _unskinnedMalFormedGuideML = @"<PICTURE embed=""Right"" shadow=""None"" H2G2IMG=""towerbridge.jpg"" ALT=""London's Tower Bridge, in silhouette."" /><P>Tower Bridge, widely regarded as the most glamorous bridge across the Thames, was built because the demand for access across the Thames in <LINK H2G2=""A6681062"">London</LINK> far exceeded the capacity of the existing bridges. Increased commercial activity in the East End was creating a need for more vehicles to be able to cross the river, downstream of London Bridge. </P><P>Sheer weight of traffic was causing huge problems, and over a period of 11 years around 30 petitions from public bodies were brought before the authorities. The most common suggestions were the building of a new bridge or the widening of London Bridge, although there was also a proposal for a railway line to be built at the bottom of the river. This would carry a travelling stage with its deck at high water level. <ERROR> Designing a bridge over a busy river with low banks was not going to be an easy task. The reason for the difficulties was that the 'pool' of London (the area between London Bridge and the Tower of London) was heavily used by river traffic, and access had to be maintained. </P><P>The pool has been heavily used since Roman times, because it meant that large ocean-going vessels could simply sail straight up the River Thames and unload their goods directly in the city; there was no need to transfer cargo to small river vessels. The river was a major transport route, and for centuries large ships docked at the wharves here to unload. This allowed their cargo to be distributed using the inland river system, and later, by Victorian canals. Although trade began moving away from the pool around the middle of the 20th Century, at the time, large vessels still needed constant access to the Pool.</P><P>In August 1882 the traffic over London Bridge was counted for two days to work out an average for a 24-hour period. At that time London Bridge was only 54 feet wide, yet was carrying over 22,000 vehicles and over 110,000 pedestrians. A committee was set up to consider the petitions and make a decision. Subways and large paddle ferries were also considered at this time. </P><HEADER>Decision-making and Design</HEADER><P>In 1878 the City architect Horace Jones proposed a bascule bridge. 'Bascule' comes from the French for 'see-saw', and a bascule bridge at street-level has two 'leaves' that can be raised on a horizontal axis to let ships pass on the river. Similar to a drawbridge, it works on a pivot with a heavy weight at one end to balance the length (weighing 1000 tons) at the other end. It would mean that steep approaches to the bridge could be avoided. His first design was rejected, but in 1884 his second was approved, and an Act of Parliament was passed in 1885 authorising its building. The Act stipulated an opening central span of 200 feet and headroom of 135 feet when the bridge was open<FOOTNOTE INDEX=""1"">The closed headroom was 29 feet to cater for the high tide, which could be 25 feet higher than low tide.</FOOTNOTE>. In practice these measurements were exceeded by five feet and six inches respectively. It was to be built in keeping with its surroundings - the Tower of London. The site was chosen because, in an area surrounded by wharves, it was cheaper to build the north side of the crossing in the Tower's ditch than it would have been to buy the land.</P><P>Horace Jones was appointed architect. His original designs were very medieval in influence, with the bascules being raised by chains. The revised design was been jointly presented with John Wolfe-Barry, a civil engineer, and was more influenced by the Victorian Gothic style, possibly because Wolfe-Barry's father had been one of the architects on the Houses of Parliament. The bridge's main towers are similar to those of a medieval Scottish castle and the bascules open like an old castle drawbridge. Many of the decorative elements on the stone façade, and the cast iron work are typical of Victorian Gothic architecture. </P><P>Horace Jones died in 1887, just over a year after building work had begun. The foundations had not been completed, and the architectural designs were still only sketches. His assistant George Stevenson took over, and changed the stonework from red brick to Portland stone and Cornish granite. Stevenson also designed many of the decorative details.</P><P>The bridge was opened to traffic by the Prince of Wales (the future King Edward VII) on 30 June, 1894, on behalf of Queen Victoria. The bridge had required eight years of construction at a cost of just over £1,000,000. The journal <I>The Builder</I> called the bridge '<I>the most monstrous and preposterous architectural sham that we have ever known</I>'.</P><HEADER>Construction</HEADER><P>Work was started on the bridge in 1886, with the Prince of Wales laying the foundation stone over a time capsule containing papers and coins. The work was intended to take only three years, but parliament was asked twice for more time. Two piers containing 70,000 tons of concrete were sunk into the river bed to support the weight of the bridge, and it was on these that the towers were built. Because the central area of the river could not be obstructed, the towers were built one at a time. The bascules had to be built in the upright position, including the wood paving.</P><P>The towers are 293 feet tall from the foundations, and are made of a steel frame to support the great weight of the bascules, clothed in stone to fit the stipulation that the bridge harmonised with the Tower of London. They contain lifts and stairs to the two walkways running between the towers. The walkways are 110 feet above the roadway and are held in place by metal girders. They were used to stabilise the bridge, and to give pedestrians a way to cross so that they did not have to wait for the bridge to be lowered before they could cross the Thames. As boats used sails less, and steam more, the bridge took only six minutes to open and close. Most pedestrians simply enjoyed the view while waiting for the bridge to close again. The walkways were closed in 1910 due to lack of use by most pedestrians - they had become home to prostitutes. They stayed closed to the public for over 70 years, although they did house some anti-aircraft guns during World War I, and have since been refurbished and re-opened as part of the visitor attractions for the bridge.</P><P>The two side-spans operate on the suspension principle; the 270-foot long approaches (decks) are hung from curved lattice girders. The girders are attached to the towers at the level of the walkway where they are linked together by a chain - each side anchoring the other. They curve down towards the road, then curve up again, reaching up and over the abutment towers at the shoreline before curving back down to the shore where they are anchored. Each chain that runs between the girders and the bridge weighs about the same as a small elephant, per metre.</P><P>The road has a width of 35 feet, with a 12.5-feet-wide pavement on either side; this makes the bridge 60 feet wide.</P><P>More detailed, technical information about the construction of the bridge can be found <LINK HREF=""http://www.hartwell.demon.co.uk/tbpic.htm"" TITLE=""Tower Bridge, London"">here</LINK>. Despite its appearance, Tower Bridge is a steel bridge, not stone, and is extremely strong. It was originally painted in a chocolate brown colour.</P><HEADER>Moving the Bascules</HEADER><P>The bridge has always been operated by hydraulics; originally the two pumping engines were powered by steam engines, and the energy stored in six accumulators, ready for use when needed. One set of engines powered the lifting engines which worked the pistons, cranks and cogs that raised the bridge, to save wear and tear. It lifted in less than one minute to 86 degrees. The south side opened slightly before the north side, as they were controlled seperately. Since 1976 the hydraulics have been powered by oil and electricity, and the bascules now open together.</P><P>When the bridge is shut, and the leaves brought together, two bolts called the 'nose bolts,' carried on each leaf, are locked by hydraulic power into sockets on the other leaf.</P><P>When the bridge needs to rise (this requires 24 hours notice), traffic lights stop the traffic. The road gates close, then the pedestrian gates close. The nose bolts are withdrawn, and the bridge lifts. The bascules only fully open for large ships, or to greet ships of importance. In their first year the bascules were raised 6160 times. Nowadays the bridge lifts around 1000 times a year to allow tall ships, cruise ships, naval vessels and other large craft to pass under, and can open and close in five minutes. The record amount of activity stands at 64 lifts in 24 hours in 1910. </P><HEADER>Action and Adventure</HEADER><P>The bridge has been the backdrop for a few exciting events, and has appeared in a number of films. These include <LINK H2G2=""A636923"">Bridget Jones's Diary</LINK>, The Mummy II, Spice World<FOOTNOTE INDEX=""2"">Where the <LINK H2G2=""A467750"">Spice Girls</LINK> jumped across the bridge as it opened in a double decker bus.</FOOTNOTE> and <LINK HREF=""http://www.imdb.com/title/tt0143145/"">The World is Not Enough</LINK>.</P><P>During the summer of 1912 the English pilot Frank McClean flew a short pusher biplane up the Thames. He failed to get sufficient height to clear the bridge, so he flew under the walkways. This event was captured by newspaper photographers, and the image became famous. He was not the only one - pilots (deliberately) flew under the walkways in 1973 and in 1978.</P><P>In 1952, a number 78 double-decker bus was unlucky enough to be on the bridge when it opened. Back then, the lights would change to red, the gateman would ring bells to encourage the pedestrians to move off the bridge quickly and close the gates, and the head watchman would order the bridge to lift when it was clear. On this day in December, there was a relief watchman, and something went wrong. Albert Gunton, the driver, saw that the road ahead appeared to be sinking. In fact, his bus was perched on the end of an opening bascule, which was giving the illusion of a sinking road ahead. He realised that he would not be able to stop in time to prevent going into the water, and making a split second decision, decided he would go for it. He accelerated and jumped the three feet gap, landing on the north bascule, which had not started to rise. None of his dozen passengers were seriously hurt, and he received £10 for his bravery. He also appeared later on '<LINK HREF=""http://www.whirligig-tv.co.uk/tv/adults/quiz/whatsmyline.htm"">What's My Line?</LINK>'</P><HEADER>Tower Bridge Exhibition</HEADER><P>The exhibition has been running for over 20 years, after a £2.5million conversion to the bridge to allow visits to the walkways and Victorian engine rooms, and to set the exhibition up. Visitors can learn about the history of the bridge and how it was built, visit the walkways and level three of the North Tower, and visit the Victorian engine rooms.</P><SUBHEADER>How to Get There</SUBHEADER><P>The nearest underground stations are Tower Hill and London Bridge. By rail it can be reached from London Bridge, Fenchurch Street and Tower Gateway on the Docklands Light Railway. </P><HEADER>Fascinating Facts</HEADER><UL><LI><P> An account of the bridge written in 1937 tells of a tugboat that stood at anchor, but with steam up and ready to go. The tug was there to go to the assistance of any vessel that was in difficulties and threatening the bridge, and to direct river traffic. The cost of maintenance for the tug was one of the conditions given for the erection of the bridge. In the 40 years it had been open at the time, the tug had hardly been used. In 1944 it was sunk by a V1 rocket which had bounced off the bridge. Unsurprisingly, a replacement was not deemed worthwhile. </P></LI><LI><P>Tower Bridge was the only bridge downstream of London Bridge until 1991, when the <LINK H2G2=""A667839"" TITLE=""The Thames River Crossings at Dartford"">Queen Elizabeth II</LINK> was built at Dartford. It was the last bridge built across the Thames in London before the Millennium Bridge opened, nearly 106 years to the day later<FOOTNOTE INDEX=""3"">The Millennium Bridge only stayed open for three days before closing for 20 months to stop a worrying 'sway'.</FOOTNOTE>. </P></LI><LI><P>Tower Bridge is the only moveable bridge on the River Thames, and is funded by an ancient trust - <LINK HREF=""http://www.bridgehousegrants.org.uk/history.htm"">Bridge House Estates</LINK> - which had been set up to manage London Bridge in the 11th Century. The trust keeps the bridge toll-free for road and river traffic, and is managed by the <LINK H2G2=""A642944"">Corporation of London</LINK>, who own and manage it. It is insured by Lloyd's of London on the shipping register as a ship, and for the first 23 years of its life, all staff were ex-sailors and servicemen.</P></LI><LI><P>Try standing in the middle of the bridge (on the pavement of course!) with one foot on each leaf. Wait for a bus or lorry to pass. Enjoy!</P></LI></UL>";

        
        static bool _keyArticlesSetup = false;

        [TestCleanup]
        public void ShutDown()
        {
            Console.WriteLine("ShutDown Article_V1");
        }

        [TestInitialize]
        public void StartUp()
        { 
            SnapshotInitialisation.RestoreFromSnapshot();
        }

        /// <summary>
        /// Constructor
        /// </summary>


        [TestMethod]
        public void CreateNewArticleWithHTML()
        {
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = HttpUtility.UrlEncode(@"<GUIDE>
    <BODY>Sample Article Content</BODY>
  </GUIDE>");
            string submittable = "YES";
            string hidden = "0";

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/create.htm", _sitename);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("style={0}&subject={1}&guideML={2}&submittable={3}&hidden={4}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML),
                 HttpUtility.UrlEncode(submittable),
                 HttpUtility.UrlEncode(hidden));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            // it's not really easy to assert the if the item was created... but we cover this in the xml based tests
        }

        [TestMethod]
        public void CreateNewArticleWithLargeGuideMLviaHTML()
        {
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE>
    <BODY>{0}</BODY>
  </GUIDE>", _unskinnedGuideML);
            string submittable = "YES";
            string hidden = "0";

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/create.htm", _sitename);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("style={0}&subject={1}&guideML={2}&submittable={3}&hidden={4}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML),
                 HttpUtility.UrlEncode(submittable),
                 HttpUtility.UrlEncode(hidden));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            // it's not really easy to assert the if the item was created... but we cover this in the xml based tests
        }

        [TestMethod]
        public void UpdateArticle_WithHTML()
        {
            string h2g2id = "586";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>");

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/create.htm/{1}", _sitename, h2g2id);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserSuperUser();

            string postData = String.Format("style={0}&subject={1}&guideML={2}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "PUT", localHeaders);

            // we cover the testing of the return values in the xml based tests
        }

        [TestMethod]
        public void UpdateArticle_WithHTML_AndCheckItsReturnedWithAFreshGet()
        {
            string h2g2id = "586";
            string style = "GuideML";
            string subject = "Test SubjectXXX";
            string guideML = String.Format(@"<GUIDE xmlns="""">
    <BODY>Sample Article ContentXXX</BODY>
  </GUIDE>");

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/create.htm/{1}", _sitename, h2g2id);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserSuperUser();

            string postData = String.Format("style={0}&subject={1}&guideML={2}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "PUT", localHeaders);

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?applySkin=false", _sitename, h2g2id);
            request.RequestPageWithFullURL(url, null, "text/xml");

            Article getArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            Assert.IsTrue(getArticle.Subject == savedArticle.Subject, "Article not saved correctly");

        }

        [TestMethod]
        public void UpdateArticle_WithResearchers_WithHTML()
        {
            string researchers = "276, 1422";
            string h2g2id = "586";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>");

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/create.htm/{1}", _sitename, h2g2id);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserSuperUser();

            string postData = String.Format("style={0}&subject={1}&guideML={2}&researcherUserIds={3}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML),
                 HttpUtility.UrlEncode(researchers));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "PUT", localHeaders);

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));
        }

        [TestMethod]
        public void PreviewArticleWithHTML()
        {
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = HttpUtility.UrlEncode(@"<GUIDE>
    <BODY>Sample Article Content</BODY>
  </GUIDE>");
            string submittable = "YES";
            string hidden = "0";

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/preview/create.htm", _sitename);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("style={0}&subject={1}&guideML={2}&submittable={3}&hidden={4}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML),
                 HttpUtility.UrlEncode(submittable),
                 HttpUtility.UrlEncode(hidden));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

        }

        [TestMethod]
        public void PreviewArticleWithLargeGuideMLWithHTML()
        {
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE>
    <BODY>{0}</BODY>
  </GUIDE>", _unskinnedGuideML);
            string submittable = "YES";
            string hidden = "0";

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/preview/create.htm", _sitename);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("style={0}&subject={1}&guideML={2}&submittable={3}&hidden={4}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML),
                 HttpUtility.UrlEncode(submittable),
                 HttpUtility.UrlEncode(hidden));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

             request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));
        }

        [TestMethod]
        public void PreviewArticleWithMalFormedGuideML_WithHTML_ReturnsWithArticleError()
        {
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE>
    <BODY>{0}</BODY>
  </GUIDE>", _unskinnedMalFormedGuideML);
            string submittable = "YES";
            string hidden = "0";

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/preview/create.htm", _sitename);

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string postData = String.Format("style={0}&subject={1}&guideML={2}&submittable={3}&hidden={4}",
                 HttpUtility.UrlEncode(style),
                 HttpUtility.UrlEncode(subject),
                 HttpUtility.UrlEncode(guideML),
                 HttpUtility.UrlEncode(submittable),
                 HttpUtility.UrlEncode(hidden));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            Assert.IsNotNull(savedArticle.XmlError, "Xml Error should not be null");
            Assert.IsTrue(savedArticle.XmlError == "GuideML Transform Failed by The 'ERROR' start tag on line 2 does not match the end tag of 'P'. Line 2, position 1201.", "Xml Error does not match");
        }

        [TestMethod]
        public void CreateNewArticleWithXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            // assert the values
            XmlDocument guideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            guideMLWithoutWhitespace.LoadXml(guideML);
            XmlDocument savedArticleGuideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            savedArticleGuideMLWithoutWhitespace.LoadXml(savedArticle.GuideMLAsString);
            Assert.AreEqual(style, savedArticle.Style.ToString());
            Assert.AreEqual(subject, savedArticle.Subject);
            Assert.AreEqual(guideMLWithoutWhitespace.OuterXml, savedArticleGuideMLWithoutWhitespace.OuterXml);
            Assert.AreEqual(BBC.Dna.Objects.Article.ArticleType.Article, savedArticle.Type);
            
            // read back article
            string getArticleUrl = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, savedArticle.H2g2Id);
            request.RequestPageWithFullURL(getArticleUrl, null, "text/xml");

            Article returnedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));
            Assert.AreEqual(returnedArticle.H2g2Id, savedArticle.H2g2Id);
            Assert.AreEqual(returnedArticle.Style, savedArticle.Style);
            Assert.AreEqual(returnedArticle.Subject, savedArticle.Subject);
            Assert.AreEqual(returnedArticle.Type, savedArticle.Type);           
        }

        [TestMethod]
        public void CreateNewArticleWithLargeGuideMLXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            RemoveNotAllowURLsonH2G2SiteOption();

            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE xmlns="""">
    <BODY>{0}</BODY>
  </GUIDE>", _unskinnedGuideML);
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            // assert the values
            XmlDocument guideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            guideMLWithoutWhitespace.LoadXml(guideML);
            XmlDocument savedArticleGuideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            savedArticleGuideMLWithoutWhitespace.LoadXml(savedArticle.GuideMLAsString);
            Assert.AreEqual(style, savedArticle.Style.ToString());
            Assert.AreEqual(subject, savedArticle.Subject);
            Assert.AreEqual(guideMLWithoutWhitespace.OuterXml, savedArticleGuideMLWithoutWhitespace.OuterXml);
            Assert.AreEqual(BBC.Dna.Objects.Article.ArticleType.Article, savedArticle.Type);

            // read back article
            string getArticleUrl = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml&applyskin=false", _sitename, savedArticle.H2g2Id);
            request.RequestPageWithFullURL(getArticleUrl, null, "text/xml");

            Article returnedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));
            Assert.AreEqual(returnedArticle.H2g2Id, savedArticle.H2g2Id);
            Assert.AreEqual(returnedArticle.Style, savedArticle.Style);
            Assert.AreEqual(returnedArticle.Subject, savedArticle.Subject);
            Assert.AreEqual(returnedArticle.Type, savedArticle.Type);
            Assert.AreEqual(returnedArticle.GuideMLAsString, savedArticle.GuideMLAsString);
        }

        [TestMethod]
        public void CreateNewArticleWith_HiddenStatus()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";
            string submittable = "YES";
            string hidden = "1";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<hidden>{4}</hidden>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML,
             hidden);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            // read back article
            string getArticleUrl = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, savedArticle.H2g2Id);
            request.RequestPageWithFullURL(getArticleUrl, null, "text/xml");

            Article returnedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));
            Assert.AreEqual(returnedArticle.HiddenStatus.ToString(), hidden);

        }


        [TestMethod]
        public void UpdateArticleWithXml()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserSuperUser();

            string h2g2id = "649";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<style>{0}</style>
<subject>{1}</subject>
<text>{2}</text>
</article>",
            style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}", _sitename, h2g2id);

            request.RequestPageWithFullURL(url, serializedData, "text/xml", "PUT");

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            // assert the return values
            XmlDocument guideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            guideMLWithoutWhitespace.LoadXml(guideML);
            XmlDocument savedArticleGuideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            savedArticleGuideMLWithoutWhitespace.LoadXml(savedArticle.GuideMLAsString);
            Assert.AreEqual(style, savedArticle.Style.ToString());
            Assert.AreEqual(subject, savedArticle.Subject);
            Assert.AreEqual(guideMLWithoutWhitespace.OuterXml, savedArticleGuideMLWithoutWhitespace.OuterXml);
            Assert.AreEqual(BBC.Dna.Objects.Article.ArticleType.Article, savedArticle.Type);
        }

        [TestMethod]
        public void UpdateArticle_WithResearchers()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserSuperUser();
           

            string research1Id = "276";
            string research2Id = "1422";
            string h2g2id = "649";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo>
<pageAuthor>
    <researchers>
        <user><userId>{3}</userId></user>
        <user><userId>{4}</userId></user>
    </researchers>
</pageAuthor>
</articleInfo>
<style>{0}</style>
<subject>{1}</subject>
<text>{2}</text>
</article>",
            style,
             subject,
             guideML, 
             research1Id,
             research2Id);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}", _sitename, h2g2id);

            request.RequestPageWithFullURL(url, serializedData, "text/xml", "PUT");

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            string getArticleUrl = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, savedArticle.H2g2Id);
            request.RequestPageWithFullURL(getArticleUrl, null, "text/xml");

            Article returnedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            Assert.AreEqual(2, savedArticle.ArticleInfo.PageAuthor.Researchers.Count);
            Assert.AreEqual(research1Id, savedArticle.ArticleInfo.PageAuthor.Researchers[0].UserId.ToString());
            Assert.AreEqual(research2Id, savedArticle.ArticleInfo.PageAuthor.Researchers[1].UserId.ToString());

        }



        [TestMethod]
        public void UpdateArticle_With_BadlyFormedH2G2Id()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserSuperUser();

            string h2g2id = "-1";
               string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><pageAuthor><user><userId>{0}</userId></user></pageAuthor></articleInfo>
<style>{0}</style>
<subject>{1}</subject>
<text>{2}</text>
</article>",
            style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}", _sitename, h2g2id);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "PUT");
            }
            catch(Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.InvalidH2G2Id.ToString(), errorData.Code);
        }



        [TestMethod]
        public void UpdateArticle_With_InvalidSiteID()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserSuperUser();

            string h2g2id = "559";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<style>{0}</style>
<subject>{1}</subject>
<text>{2}</text>
</article>",
            style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}", "BADSITE", h2g2id);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "PUT");
            }
            catch (Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);
        }



        [TestMethod]
        public void UpdateArticle_With_Hidden()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserEditor();

            string h2g2id = "630";
            string hidden = "1";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<style>{0}</style>
<hidden>{3}</hidden>
<subject>{1}</subject>
<text>{2}</text>
</article>",
            style,
             subject,
             guideML,
             hidden);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}", _sitename, h2g2id);


            request.RequestPageWithFullURL(url, serializedData, "text/xml", "PUT");
        }

        /// <summary>
        /// Tests if the correct exception is thrown when a normal user tries to edit an article created by another user
        /// </summary>
        [TestMethod]
        public void UpdateArticle_As_UserWithoutPermission()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();  

            string h2g2id = "559";
            string hidden = "1";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<style>{0}</style>
<hidden>{3}</hidden>
<subject>{1}</subject>
<text>{2}</text>
</article>",
            style,
             subject,
             guideML,
             hidden);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}", _sitename, h2g2id);


            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "PUT");
            }
            catch (Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UserDoesNotHavePermissionToEditArticle.ToString(), errorData.Code);            
        }


        [TestMethod]
        public void CreateArticle_With_InvalidSiteID()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", "BADSITE");
            
            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");
            }
            catch (Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);            

        }

        [TestMethod]
        public void CreateArticle_With_EmptySubject()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content</BODY>
  </GUIDE>";
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");
            }
            catch (Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MissingSubject.ToString(), errorData.Code);
        }


        [TestMethod]
        public void CreateArticle_With_UrlInTextFails_WhenSiteOptionDoesNotAllowURLs()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            AddNotAllowURLsonH2G2SiteOption();

            try
            {
                string style = "GuideML";
                string subject = "Subject";
                string guideML = @"<GUIDE xmlns="""">
        <BODY><a href=""http://www.atestlink.com"">This is a link</a></BODY>
      </GUIDE>";
                string submittable = "YES";

                string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
    <article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
    <articleInfo><submittable><type>{0}</type></submittable></articleInfo>
    <style>{1}</style>
    <subject>{2}</subject>
    <text>{3}</text>
    </article>",
                submittable,
                 style,
                 subject,
                 guideML);


                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

                try
                {
                    request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");
                }
                catch (Exception)
                {
                }

                Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
                ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
                Assert.AreEqual(ErrorType.ArticleContainsURLs.ToString(), errorData.Code);
            }
            finally
            {
                RemoveNotAllowURLsonH2G2SiteOption();
            }
        }

        [TestMethod, Ignore]
        public void CreateArticle_With_EmailInText()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>email@www.test-email.com</BODY>
  </GUIDE>";
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");
            }
            catch (Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ArticleContainsEmailAddress.ToString(), errorData.Code);
        }

        [TestMethod]
        public void CreateArticle_With_Profanity()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Fuck</BODY>
  </GUIDE>";
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");
            }
            catch (Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ProfanityFoundInText.ToString(), errorData.Code);
        }

        [TestMethod, Ignore]
        public void CreateArticle_With_SomeEmptyGuideML()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string submittable = "YES";
            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY></BODY>
  </GUIDE>";           
            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");
            }
            catch (Exception)
            {
            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MissingGuideML.ToString(), errorData.Code);

        }



        [TestMethod]
        public void CreateArticle_With_Hidden()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Subject "  + Guid.NewGuid().ToString();
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content" +  Guid.NewGuid().ToString() + @"</BODY>
  </GUIDE>";
            string submittable = "YES";
            string hidden = "1"; // ie. hidden = true

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<hidden>{4}</hidden>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML,
             hidden);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);
            
            request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");

            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            // read back article
            string getArticleUrl = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, savedArticle.H2g2Id);
            request.RequestPageWithFullURL(getArticleUrl, null, "text/xml");

            Article returnedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            Assert.AreEqual("1", returnedArticle.HiddenStatus.ToString());  // ie. visible = false
        }

        [TestMethod]
        public void CreateArticle_With_NotHidden()
        {
            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Subject";
            string guideML = @"<GUIDE xmlns="""">
    <BODY>Sample Article Content" + Guid.NewGuid().ToString() + @"</BODY>
  </GUIDE>";
            string submittable = "YES";
            string hidden = "0";


            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<hidden>{4}</hidden>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML,
             hidden);


            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles", _sitename);

            request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");

            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            // read back article
            string getArticleUrl = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, savedArticle.H2g2Id);
            request.RequestPageWithFullURL(getArticleUrl, null, "text/xml");


            Article returnedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            Assert.AreEqual("0", returnedArticle.HiddenStatus.ToString());  
        }


        public Article_V1()
        {
        }

        /// <summary>
        /// Tests if the article API correctly performs a transform on the GUIDEML, if instructed to do so.
        /// </summary>
        [TestMethod]
        public void GetArticle_WithApplySkin_ReturnsSkinnedXml()            
        {
            SnapshotInitialisation.RestoreFromSnapshot();

            int articleId = 649;

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?applySkin=true", _sitename, articleId);
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();
            string bodyContent = xml["article"]["text"]["GUIDE"]["BODY"].InnerXml;

            Assert.AreEqual(_AerianSkinnedGuideML, bodyContent);
        }

        /// <summary>
        /// Tests if the article API returns the GUIDEML if instructed to not do a transform
        /// </summary>
        [TestMethod]
        public void GetArticle_WithDoNotApplySkin_ReturnsUnskinnedXml()            
        {
            int articleId = 559;

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?applySkin=false", _sitename, articleId);
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();
            string bodyContent = xml["article"]["text"]["GUIDE"]["BODY"].InnerXml;

            Assert.AreEqual(_unskinnedGuideML, bodyContent);
        }

        /// <summary>
        /// Test CreateArticle method from service
        /// </summary>
        [TestMethod]
        public void GetArticle_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetArticle_ReadOnly_ReturnsValidXml");

            int[] ids = { 559, 586, 630, 649, 667, 883, 937, 964, 1251, 1422, 79526,87130,87310,
                            88274,88319,88373,89804,91298,92369,92440,92495,99119,99452,99524,101755,101782};
               

            foreach (var id in ids)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                 request.SetCurrentUserNormal();

                Console.WriteLine("Validing ID:" + id);
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, id);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetArticle_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test CreateRandomArticle method from service
        /// </summary>
        [TestMethod]
        public void GetRandomArticle_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetRandomArticle_ReadOnly_ReturnsValidXml");
                
            for (int i = 0; i < 5; i++)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                request.SetCurrentUserNormal();

                Console.WriteLine("Get Random Article");
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/random?type=Edited&format=xml", _sitename);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetRandomArticle_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetComingUpArticles method from service
        /// </summary>
        [TestMethod]
        public void GetComingUpArticles_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetComingUpArticles_ReadOnly_ReturnsValidXml");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
        request.SetCurrentUserNormal();

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/comingup?format=xml", _sitename);
            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            // Check to make sure that the page returned with the correct information
            XmlDocument xml = request.GetLastResponseAsXML();


            Console.WriteLine("After GetComingUpArticles_ReadOnly_ReturnsValidXml");
        }
        /// <summary>
        /// Test GetMonthlySummary method from service
        /// </summary>
        [TestMethod]
        public void GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound()
        {
            Console.WriteLine("Before GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound");
            ClearArticlesForTheLastMonthForMonthSummaryFail();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNotLoggedInUser();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/month?format=xml", _sitename);

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MonthSummaryNotFound.ToString(), errorData.Code);

            Console.WriteLine("After GetMonthlySummaryArticles_FailsWithMonthSummaryNotFound");
        }
        /// <summary>
        /// Test GetMonthlySummaryArticles_WithSomeArticles method from service
        /// </summary>
        [TestMethod]
        public void GetMonthlySummaryArticles_WithSomeArticles()
        {
            Console.WriteLine("Before GetMonthlySummaryArticles_WithSomeArticles");
            
            SetupMonthSummaryArticle();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);

            request.SetCurrentUserNormal();

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/month?format=xml", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            Console.WriteLine("After GetMonthlySummaryArticles_WithSomeArticles");
        }

        /// <summary>
        /// Test GetSearchArticles method from service
        /// Needs guide entry cat on smallguide created
        /// </summary>
                   
        [TestMethod]
        public void GetSearchArticles_VariousTerms_ReturnsValidResults()
        {
            SetupFullTextIndex();
            
            Console.WriteLine("Before GetSearchArticles");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            var testData = new string[]{ "dinosaur", "cats and dogs", "the is a bad stop word", "The Hitchhiker's Guide to the Galaxy"  };

            foreach (var term in testData)
            {
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles?querystring={1}&showapproved=1&searchtype=ARTICLE&format=xml", _sitename, term);

                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                BBC.Dna.Objects.Search returnedSearch = (BBC.Dna.Objects.Search)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(BBC.Dna.Objects.Search));

                Assert.IsTrue(returnedSearch.SearchResults.Count > 0);
                Assert.AreEqual(term, returnedSearch.SearchResults.SearchTerm);
            }
            Console.WriteLine("After GetSearchArticles");
        }

        /// <summary>
        /// Test ClipArticle method from service
        /// </summary>
        [TestMethod]
        public void ClipArticle()
        {
            Console.WriteLine("Before ClipArticle");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1021825/clip/", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After ClipArticle");
        }

        /// <summary>
        /// Test TryClipArticleTwice method from service
        /// </summary>
        [TestMethod]
        public void TryClipArticleTwice()
        {
            Console.WriteLine("Before TryClipArticleTwice");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1422/clip/", _sitename);

            request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");

            /*
            try
            {
                request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");
            }
            catch (WebException)
            {

            }
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.AlreadyLinked.ToString(), errorData.Code);
            */

            //Will no longer throw error will just carry on
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After TryClipArticleTwice");
        }

        [TestMethod]
        public void ClipArticle_UnknownSite_Returns404()
        {
            Console.WriteLine("Before ClipArticle_UnknownSite_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            string unknownSite = "unknown_site";

            Console.WriteLine("Validing site:" + unknownSite);
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1422/clip/", unknownSite);

            DateTime dt = DateTime.Now;
            String timeStamp = dt.ToString("ddddyyyyMMMMddHHmmssfffffff");
            try
            {
                request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.UnknownSite.ToString(), errorData.Code);

            Console.WriteLine("After ClipArticle_UnknownSite_Returns404");
        }

        [TestMethod]
        public void ClipArticle_NotLoggedInUser_Returns404()
        {
            Console.WriteLine("Before ClipArticle_NotLoggedInUser_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1422/clip/", _sitename);

            DateTime dt = DateTime.Now;
            String timeStamp = dt.ToString("ddddyyyyMMMMddHHmmssfffffff");
            try
            {
                request.RequestPageWithFullURL(url, makeTimestamp(), "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.Unauthorized, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.MissingUserCredentials.ToString(), errorData.Code);

            Console.WriteLine("After ClipArticle_NotLoggedInUser_Returns404");
        }

        /// <summary>
        /// Test CreateNamedArticle method from service
        /// </summary>
            
        [TestMethod]
        public void GetNamedArticle_ReadOnly_ReturnsValidXml()
        {
            SetupKeyNamedArticles();
            Console.WriteLine("Before GetNamedArticle_ReadOnly_ReturnsValidXml");
            
            string[] names = { "Askh2g2", "Feedback", "Writing-Guidelines", "GuideML-Introduction", "Welcome" };
              

            foreach (var name in names)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                  request.SetCurrentUserNormal();

                Console.WriteLine("Validing Name:" + name);
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/name/{1}?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetNamedArticle_ReadOnly_ReturnsValidXml");
        }

        /// <summary>
        /// Test CreateNamedArticle method from service
        /// </summary>           
        [TestMethod]
        public void GetNamedArticleViaGetArticles_ReadOnly_ReturnsValidXml()
        {
            Console.WriteLine("Before GetNamedArticleViaGetArticles_ReadOnly_ReturnsValidXml");
             SetupKeyNamedArticles();


            string[] names = { "Askh2g2", "Feedback", "Writing-Guidelines", "GuideML-Introduction", "Welcome" };
              

            foreach (var name in names)
            {
                DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
                  request.SetCurrentUserNormal();

                Console.WriteLine("Validing Name:" + name);
                string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}?format=xml", _sitename, name);
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
                // Check to make sure that the page returned with the correct information
                XmlDocument xml = request.GetLastResponseAsXML();
                DnaXmlValidator validator = new DnaXmlValidator(xml.InnerXml.Replace("xmlns=\"http://schemas.datacontract.org/2004/07/BBC.Dna.Objects\"", ""), _schemaArticle);
                validator.Validate();
            }
            Console.WriteLine("After GetNamedArticleViaGetArticles_ReadOnly_ReturnsValidXml");
        }

           
        [TestMethod]
        public void GetNamedArticle_UnknownArticle_Returns404()
        {
             SetupKeyNamedArticles();
            Console.WriteLine("Before GetNamedArticle_UnknownArticle_Returns404");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;

            string unknownArticle = "IAmTheUnknownArticle";

            Console.WriteLine("Validing site:" + unknownArticle);
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/name/{1}?format=xml", _sitename, unknownArticle);

            try
            {
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.NotFound, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.ArticleNotFound.ToString(), errorData.Code);

        }

        /// <summary>
        /// Test SubmitArticleForReview method from service
        /// </summary>
        [TestMethod]
        public void SubmitArticleForReview()
        {
            Console.WriteLine("Before SubmitArticleForReview");

            SnapshotInitialisation.RestoreFromSnapshot();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/570935/submitforreview/create.htm", _sitename);

            string postData = String.Format("reviewforumid={0}&comments={1}",
                 HttpUtility.HtmlEncode("1"),
                 HttpUtility.HtmlEncode("thisisforreview"));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After SubmitArticleForReview");
        }

        /// <summary>
        /// Test ScoutRecommendArticle method from service
        /// </summary>
        [TestMethod]
        public void ScoutRecommendArticle()
        {
            Console.WriteLine("Before ScoutRecommendArticle");

            SnapshotInitialisation.RestoreFromSnapshot();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserSuperUser();

            //First submit an article for review
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1319456/submitforreview/create.htm", _sitename);

            string postData = String.Format("reviewforumid={0}&comments={1}",
                 HttpUtility.HtmlEncode("1"),
                 HttpUtility.HtmlEncode("thisisforreview"));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);


            //then scout recommend it
            url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/1319456/scoutrecommends/create.htm", _sitename);

            postData = String.Format("comments={0}",
                 HttpUtility.HtmlEncode("thisisscoutrecommended"));

            localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            // now get the response
            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After ScoutRecommendArticle");
        }

        /// <summary>
        /// Test SubmitSubbedArticle method from service
        /// </summary>
        [TestMethod]
        public void SubmitSubbedArticle()
        {
            Console.WriteLine("Before SubmitSubbedArticle");

            SnapshotInitialisation.RestoreFromSnapshot();

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserSuperUser();
            int articleId = 24088034;
            AlterSubEditorForArticle(request.CurrentUserID, articleId);

            //then scout recommend it
            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/{1}/submitsubbed/create.htm", _sitename, articleId);

            string postData = String.Format("comments={0}",
                 HttpUtility.HtmlEncode("thisisreturningfromasubeditor"));

            NameValueCollection localHeaders = new NameValueCollection();
            localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
            string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

            // now get the response
            request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);

            Console.WriteLine("After SubmitSubbedArticle");
        }

        private void AlterSubEditorForArticle(int userId, int h2g2Id)
        {
            int entryId = h2g2Id / 10;
            //set max char option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    var sql = String.Format("update acceptedrecommendations set SubEditorID={0} where entryID={1}",userId, entryId );
                    reader.ExecuteDEBUGONLY(sql);
                }
            }
        }
     
        /// <summary>
        /// Test SubmitArticle method from service with no comments returns error
        /// </summary>
        [TestMethod]
        public void SubmitArticleForReviewWithNoComments()
        {
            Console.WriteLine("Before SubmitArticleForReviewWithNoComments");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/570935/submitforreview/create.htm", _sitename);

            try
            {
                // now get the response
                string postData = String.Format("reviewforumid={0}",
                     HttpUtility.HtmlEncode("1"));

                NameValueCollection localHeaders = new NameValueCollection();
                localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
                string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

                request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.EmptyText.ToString(), errorData.Code);

            Console.WriteLine("After SubmitArticleForReviewWithNoComments");
        }

        /// <summary>
        /// Test SubmitArticle method from service for an article not for review returns error
        /// </summary>
        [TestMethod]
        public void SubmitArticleNotForReview()
        {
            Console.WriteLine("Before SubmitArticleNotForReview");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/712216/submitforreview/create.htm", _sitename);

            try
            {
                // now get the response
                string postData = String.Format("reviewforumid={0}&comments={1}",
                     HttpUtility.HtmlEncode("1"),
                     HttpUtility.HtmlEncode("thisisforreview"));

                NameValueCollection localHeaders = new NameValueCollection();
                localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
                string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

                request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.NotForReview.ToString(), errorData.Code);

            Console.WriteLine("After SubmitArticleNotForReview");
        }

        /// <summary>
        /// Test SubmitArticle method from service for an article with incorrect reviewforumid returns error
        /// </summary>
        [TestMethod]
        public void SubmitArticleToIncorrectReviewForum()
        {
            Console.WriteLine("Before SubmitArticleToIncorrectReviewForum");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/171659/submitforreview/create.htm", _sitename);

            try
            {
                // now get the response
                string postData = String.Format("reviewforumid={0}&comments={1}",
                     HttpUtility.HtmlEncode("0"),
                     HttpUtility.HtmlEncode("thisisforreview"));

                NameValueCollection localHeaders = new NameValueCollection();
                localHeaders.Add("referer", "http://www.bbc.co.uk/dna/h2g2/?test=1");
                string expectedResponse = localHeaders["referer"] + "&resultCode=" + ErrorType.Ok.ToString();

                request.RequestPageWithFullURL(url, postData, "application/x-www-form-urlencoded", "POST", localHeaders);

            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.InternalServerError, request.CurrentWebResponse.StatusCode);
            ErrorData errorData = (ErrorData)StringUtils.DeserializeObject(request.GetLastResponseAsXML().OuterXml, typeof(ErrorData));
            Assert.AreEqual(ErrorType.AddIntoReviewForumFailed.ToString(), errorData.Code);

            Console.WriteLine("After SubmitArticleToIncorrectReviewForum");
        }

        /// <summary>
        /// Test GetSoloGuideEntries method from service
        /// </summary>
        [TestMethod]
        public void GetSoloGuideEntries()
        {
            Console.WriteLine("Before GetSoloGuideEntries");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/solo?format=xml", _sitename);

            // now get the response
            request.RequestPageWithFullURL(url, null, "text/xml");
            XmlDocument xml = request.GetLastResponseAsXML();

            Console.WriteLine("After GetSoloGuideEntries");
        }

        /// <summary>
        /// Tests if the article stats for h2g2 can be retrieved and deserialized
        /// </summary>
        [TestMethod]
        public void GetSiteStatisticsTest_ReturnsValidValues()
        {
            Console.WriteLine("Before GetSiteStatisticsTest_ReturnsValidValues");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.SetCurrentUserNormal();
            request.AssertWebRequestFailure = false;

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/info", _sitename);

            try
            {
                // now get the response
                request.RequestPageWithFullURL(url, null, "text/xml");
            }
            catch (WebException)
            {

            }
            Assert.AreEqual(HttpStatusCode.OK, request.CurrentWebResponse.StatusCode);
            
            SiteStatistics returnedStats = (SiteStatistics)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(SiteStatistics));

            Console.WriteLine("After GetSiteStatisticsTest_ReturnsValidValues");
        }

        [TestMethod]
        public void PreviewArticleWithXml_ReturnsValidValues()
        {
            Console.WriteLine("Before PreviewNewArticleWithXml_ReturnsValidValues");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE xmlns="""">
    <BODY>{0}</BODY>
  </GUIDE>", _unskinnedGuideML);
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/preview?applySkin=false", _sitename);

            request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");

            // test deserializiation
            Article savedArticle = (Article)StringUtils.DeserializeObject(request.GetLastResponseAsString(), typeof(Article));

            // assert the values
            XmlDocument guideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            guideMLWithoutWhitespace.LoadXml(guideML);
            XmlDocument savedArticleGuideMLWithoutWhitespace = new XmlDocument() { PreserveWhitespace = false };
            savedArticleGuideMLWithoutWhitespace.LoadXml(savedArticle.GuideMLAsString);
            Assert.AreEqual(style, savedArticle.Style.ToString());
            Assert.AreEqual(subject, savedArticle.Subject);
            Assert.AreEqual(guideMLWithoutWhitespace.OuterXml, savedArticleGuideMLWithoutWhitespace.OuterXml);
            Assert.AreEqual(BBC.Dna.Objects.Article.ArticleType.Article, savedArticle.Type);

            Console.WriteLine("After PreviewNewArticleWithXml_ReturnsValidValues");
        }

        [TestMethod]
        public void PreviewArticleWithMalFormedGuideML_ReturnsError()
        {
            Console.WriteLine("Before PreviewNewArticleWithMalFormedGuideML_ReturnsError");

            DnaTestURLRequest request = new DnaTestURLRequest(_sitename);
            request.AssertWebRequestFailure = false;
            request.SetCurrentUserNormal();

            string style = "GuideML";
            string subject = "Test Subject";
            string guideML = String.Format(@"<GUIDE xmlns="""">
    <BODY>{0}</BODY>
  </GUIDE>", _unskinnedMalFormedGuideML);
            string submittable = "YES";

            string serializedData = String.Format(@"<?xml version=""1.0"" encoding=""utf-8""?>
<article xmlns:i=""http://www.w3.org/2001/XMLSchema-instance"" xmlns=""http://schemas.datacontract.org/2004/07/BBC.Dna.Objects"">
<articleInfo><submittable><type>{0}</type></submittable></articleInfo>
<style>{1}</style>
<subject>{2}</subject>
<text>{3}</text>
</article>",
            submittable,
             style,
             subject,
             guideML);

            string url = String.Format("http://" + _server + "/dna/api/articles/ArticleService.svc/V1/site/{0}/articles/preview", _sitename);

            try
            {
                request.RequestPageWithFullURL(url, serializedData, "text/xml", "POST");
            }
            catch (WebException)
            {

            }

            Assert.AreEqual(HttpStatusCode.BadRequest, request.CurrentWebResponse.StatusCode);

            string str = request.GetLastResponseAsString();

            Console.WriteLine("After PreviewNewArticleWithMalFormedGuideML_ReturnsError");
        }

        #region SetupFunctions

        private static void SetupKeyNamedArticles()
        {

            if (!_keyArticlesSetup)
            {
                Dictionary<string, int> namedarticles = new Dictionary<string, int>()
                            { {"Feedback", 5734},
                            {"Welcome", 53146},
                            {"EditedGuide-Guidelines", 53209},
                            {"Writing-Guidelines", 53209},
                            {"Copyright", 109748},
                            {"Trademarks", 109748},
                            {"MiscChat", 121096},
                            {"Privacy", 122275},
                            {"terms", 122284},
                            {"WordOfTheDay", 142147},
                            {"Askh2g2", 148907},
                            {"GuideML-Introduction", 155701},
                            {"Smiley", 155909},
                            {"Welcome-DNA", 157349} };

                IInputContext context = DnaMockery.CreateDatabaseInputContext();
                using (IDnaDataReader reader = context.CreateDnaDataReader(""))
                {
                    foreach (KeyValuePair<string, int> namedarticle in namedarticles)
                    {
                        String sql = String.Format("exec setkeyarticle '{0}', {1}, 1, 1", namedarticle.Key, namedarticle.Value);

                        reader.ExecuteDEBUGONLY(sql);
                    }





                }
                _keyArticlesSetup = true;
            }
        }

        private static void SetupFullTextIndex()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY("CREATE FULLTEXT CATALOG GuideEntriesCat WITH ACCENT_SENSITIVITY = OFF");
                reader.ExecuteDEBUGONLY("CREATE FULLTEXT INDEX ON dbo.GuideEntries(Subject, text) KEY INDEX PK_GuideEntries ON GuideEntriesCat WITH CHANGE_TRACKING AUTO");
            }

            //wait a bit for the cat to be filled
            System.Threading.Thread.Sleep(20000);
        }

        private static void ClearArticlesForTheLastMonthForMonthSummaryFail()
        {
            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {
                reader.ExecuteDEBUGONLY(string.Format("update guideentries set datecreated = DATEADD(month, -2, getdate()) where datecreated > DATEADD(month, -1, getdate())"));
            }
        }

        private static void SetupMonthSummaryArticle()
        {
            int entryId = 0;

            IInputContext context = DnaMockery.CreateDatabaseInputContext();
            using (IDnaDataReader reader = context.CreateDnaDataReader(""))
            {

                reader.ExecuteDEBUGONLY("SELECT TOP 1 * from guideentries where status=1 and siteid=1 ORDER BY EntryID DESC");
                if (reader.Read())
                {
                    entryId = reader.GetInt32("entryid");
                }
                if (entryId > 0)
                {
                    reader.ExecuteDEBUGONLY(string.Format("update guideentries set datecreated = getdate() where entryid={0}", entryId));
                }
            }
        }
        private String makeTimestamp()
        {
            DateTime dt = DateTime.Now;
            String timeStamp = dt.ToString("ddddyyyyMMMMddHHmmssfffffff");
            return timeStamp;
        }
        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        private void RemoveNotAllowURLsonH2G2SiteOption()
        {
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    reader.ExecuteDEBUGONLY("delete from siteoptions where name='IsURLFiltered' and siteid=1");
                }
            }
            DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/h2g2/?action=recache-site&siteid=1", "", "text/xml");

        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        private void AddNotAllowURLsonH2G2SiteOption()
        {
            //set max char option
            using (FullInputContext inputcontext = new FullInputContext(""))
            {
                using (IDnaDataReader reader = inputcontext.CreateDnaDataReader(""))
                {
                    var sql = String.Format("select * from siteoptions where siteid={0} and name='IsURLFiltered' and Value=1", 1);
                    reader.ExecuteDEBUGONLY(sql);
                    if (reader.HasRows)
                    {
                        return;
                    }
                    else
                    {
                        sql = String.Format("select * from siteoptions where siteid={0} and name='IsURLFiltered' and Value=0", 1);
                        reader.ExecuteDEBUGONLY(sql);
                        if (reader.HasRows)
                        {
                            sql = String.Format("update siteoptions set Value=1 where siteid={0} and name='IsURLFiltered'", 1);
                            reader.ExecuteDEBUGONLY(sql);
                        }
                        else
                        {
                            sql = String.Format("insert into siteoptions values ('General', 1,  'IsURLFiltered', 1, 1, 'Turns on and off allow URL in articles functionality')");
                            reader.ExecuteDEBUGONLY(sql);
                        }
                    }
                }
            }
            DnaTestURLRequest myRequest = new DnaTestURLRequest(_sitename);
            myRequest.RequestPageWithFullURL("http://" + _server + "/dna/api/comments/CommentsService.svc/V1/site/h2g2/?action=recache-site&siteid=1", "", "text/xml");

        }

    }
}

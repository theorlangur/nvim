var vsda_location = 'C:\\Users\\DmitryD\\AppData\\Local\\Programs\\Microsoft VS Code\\resources\\app\\node_modules.asar.unpacked\\vsda\\build\\Release\\vsda.node';
var a = require(vsda_location);
var signer = new a.signer();
process.argv.forEach(function (value, index, array) {
    if (index >= 2) {
        var r = signer.sign(value);
        console.log(r);
    }
});

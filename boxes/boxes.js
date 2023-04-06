
/**
 * Returns a mapping of file names in the given directory to json parsed from that file. Non-json files are ignored.
 * 
 * @param {String} pathToDirectory Path to directory with dialog files.
 * @returns {Map} Map of parsed json. Key is file name value is parsed json.
 */
const getFileToJsonMapAtDirectory = (pathToDirectory) => {
    const result = new Map();
    fs.readdirSync(pathToDirectory).forEach(fileName => {
        if (!fileName.endsWith(".json")) return;
        console.log("reading", fileName);
        try {
            const fileData = fs.readFileSync(`${pathToDirectory}/${fileName}`, 'utf-8');
            const parsedJson = JSON.parse(fileData, 'utf-8');
            result.set(fileName, parsedJson);
        } catch (err) {
            console.error(err);
        }
    });
    return result;
};
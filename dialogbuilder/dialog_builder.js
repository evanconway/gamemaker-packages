const fs = require('fs');

const VALID_STEP_FIELDS = ["name", "text", "options", "goto", "is_end"];
const VALID_LANGUAGES = ["eng", "zho", "fre", "ger", "ita", "jpn", "kor", "pol", "por", "rus", "spa"];
const VALID_OPTION_FIELDS = ["text", "goto"];

const AUTO_NAME_PREFIX = "auto_name_";

const throwErr = (errorMessage) => {
    throw new Error(errorMessage);
};

const isObject = (obj) => {
    return obj && typeof obj === 'object';
}

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

/**
 * Given a valid step object, make a copy of it. Shorthand is removed.
 * 
 * @param {Object} step 
 * @returns {Object}
 */
const copyValidStep = (step) => {
    const result = {
        name: step.name ? step.name : "",
        text: step.text,
        options: [],
        goto: step.goto ? step.goto : "",
        is_end: Object.keys(step).includes("is_end") ? step.is_end : false
    };

    if (Array.isArray(step.options)) step.options.forEach(option => {
        const optionCopy = {
            text: {},
            goto: option.goto
        };
        Object.keys(option.text).forEach(lang => {
            optionCopy.text[lang] = option.text[lang];
        });
        result.options.push(optionCopy);
    });
    return result;
};

/**
 * Given a dialog step, return a step with the same properties, but all shorthand removed. This function
 * does not ensure that dialog step is valid relative to other steps.
 * 
 * @param {String} fileName Name of the file this step object comes from.
 * @param {Number} stepIndex The index number of the given step object.
 * @param {Object} dialogStep The step object parsed from json.
 * @returns 
 */
const makeDialogStepValid = (fileName, stepIndex, dialogStep) => {
    if (!isObject(dialogStep)) throw new Error("step is not json object");
    const fields = Object.keys(dialogStep);

    // ensure only valid field names are in object
    fields.forEach(key => {
        if (!VALID_STEP_FIELDS.includes(key)) throwErr(`invalid field "${key}" found`);
    })
    
    // ensure auto name was not used manually
    if (typeof(dialogStep.name) === 'string' && dialogStep.name.startsWith(AUTO_NAME_PREFIX)) throwErr(`names may not start with ${AUTO_NAME_PREFIX}`);

    // validate text field
    if (!fields.includes("text")) throwErr("steps must include text field");
    if (!isObject(dialogStep.text)) throwErr("text field must be object where each field name is a language code, and its value is text");
    const textLangs = Object.keys(dialogStep.text);
    textLangs.forEach(lang => {
        if (!VALID_LANGUAGES.includes(lang)) throwErr(`text field contains unrecognized language "${lang}"`);
        if (typeof(dialogStep.text[lang]) !== "string") throwErr("invalid value for language: " + lang);
    })

    // validate options
    if (fields.includes("options")) {
        if (!Array.isArray(dialogStep.options)) throwErr("options field must be array");
        dialogStep.options.forEach(option => {
            if (!isObject(option)) throwErr("each option must be an object");
            const optionFields = Object.keys(option);
            if (!optionFields.includes("text")) throwErr("options must include text field");
            if (!optionFields.includes("goto")) throwErr("options must include goto field");
            optionFields.forEach(optionField => {
                if (!VALID_OPTION_FIELDS.includes(optionField)) throwErr(`option has invalid field "${optionField}"`);
            });

            // validate option text field
            if (!isObject(option.text)) throwErr("option text field must be object with languages as fields");
            Object.keys(option.text).forEach(lang => {
                if (!VALID_LANGUAGES.includes(lang)) throwErr("option text field contains unrecognized language");
                if (typeof(option.text[lang]) !== "string") throwErr("option text has invalid value for language: " + lang);
            });
        });
    }

    // validate is_end
    if (fields.includes("is_end") && typeof(dialogStep.is_end) !== 'boolean') throwErr("is_end must be a boolean");

    // begin constructing valid step
    const result = copyValidStep(dialogStep);

    // add missing translation for missing languages in text
    VALID_LANGUAGES.forEach(lang => {
        if (Object.keys(result.text).includes(lang)) return;
        result.text[lang] = "missing translation for " + lang;
    });

    // add missing translation for missing languages in options
    result.options.forEach(option => {
        VALID_LANGUAGES.forEach(lang => {
            if (Object.keys(option.text).includes(lang)) return;
            option.text[lang] = "missing translation for " + lang;
        });
    });

    return result;
}

/**
 * Given a mapping of filenames to arrays of shorthand step objects. Return a mapping
 * of same filenames to arrays of full step objects with same properties.
 * 
 * @param {Map} jsonMap Mapping of filenames to array of shorthand step objects.
 * @returns {Map} Mapping of filenames to array of validated, non-shorthand step objects.
 */
const getValidStepFileToJsonMap = (jsonMap) => {
    const result = new Map();
    jsonMap.forEach((parsedJson, fileName) => {
        if (!Array.isArray(parsedJson)) throwErr(`json parsed from ${fileName} must be array of step objects`);
        result.set(fileName, parsedJson.map((step, i) => makeDialogStepValid(fileName, i, step)));
    });
    return result;
};

/**
 * Given a mapping of fileNames to arrays of validated steps, returns a mapping of same
 * file names and steps, but with steps validated relative to eachother. Steps are checked 
 * for unique names, gotos with valid entries, no duplicate names, and auto generated 
 * names for steps lacking names.
 * 
 * @param {Map} fileNameStepArrMap Mapping of filenames to arrays of validated steps.
 */
const getStepConnectionsValidated = (fileNameStepArrMap) => {
    const uniqueNameCheck = new Set();
    let autoNameIndex = 0;

    const result = new Map();

    fileNameStepArrMap.forEach((stepsArr, fileName) => {
        result.set(fileName, []);

        const fileStepName = new Set();

        // create copy of steps with unique names checked and empty ones auto generated
        stepsArr.forEach((step, i) => {
            const copy = copyValidStep(step);
            if (copy.name === "") copy.name = (AUTO_NAME_PREFIX + autoNameIndex++);
            if (!uniqueNameCheck.has(copy.name)) uniqueNameCheck.add(copy.name);
            else throwErr(`step name ${copy.name} in ${fileName} index ${i} is not unique`);

            fileStepName.add(copy.name);

            result.get(fileName).push(copy);
        });

        // ensure options in steps have valid gotos (gotos should only point to steps in the same file)
        result.get(fileName).forEach((step, i) => {
            step.options.forEach(option => {
                if (!fileStepName.has(option.goto)) throwErr(`goto ${option.goto} for option in step index ${i} file ${fileName} is not the name of any step in that file`);
            });
        })
    });
    return result;
};

const fileNameJsonMap = getFileToJsonMapAtDirectory("c:/Users/Evan/Documents/GameMakerStudio2/gamemaker-packages/dialogbuilder/dialog");

const mapStepsValidated = getValidStepFileToJsonMap(fileNameJsonMap);

const mapConnectedSteps = getStepConnectionsValidated(mapStepsValidated);

console.log(mapConnectedSteps);

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
 * @param {String} pathToDirectory path to directory with dialog files
 * @returns {any[]} array of each parsed json file
 */
const readJsonAtDirectory = (pathToDirectory) => {
    const result = [];
    fs.readdirSync(pathToDirectory).forEach(fileName => {
        if (!fileName.endsWith(".json")) return;
        try {
            const fileData = fs.readFileSync(`${pathToDirectory}/${fileName}`, 'utf-8');
            const parsedJson = JSON.parse(fileData, 'utf-8');
            result.push(parsedJson);
        } catch (err) {
            console.error(err);
        }
    });
    return result;
};

const makeDialogStepValid = (dialogStep) => {
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
                if (!["text", "goto"].includes(optionField)) throwErr(`option has invalid field "${optionField}"`);
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
    const result = {
        name: dialogStep.name ? dialogStep.name : "",
        text: dialogStep.text,
        options: fields.includes("options") ? dialogStep.options : [],
        goto: dialogStep.goto ? dialogStep.goto : "",
        is_end: fields.includes("is_end") ? dialogStep.is_end : false
    };

    // add missing translation for missing languages
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
 * 
 * @param {any[][]} json array of array of json, error will be thrown if not a 2D array
 */
const getValidStepsFromJson = (json) => {
    const result = [];
    if (!Array.isArray(json)) throw new Error("json must be array of array");
    json.forEach(jsonArr => {
        if (!Array.isArray(jsonArr)) throw new Error("each dialog file must be array of step objects");
        jsonArr.forEach(step => result.push(makeDialogStepValid(step)));
    });
    return result;
};

const json = readJsonAtDirectory("c:/Users/Evan/Documents/GameMakerStudio2/gamemaker-packages/dialogbuilder/dialog");

const validSteps = getValidStepsFromJson(json);

console.log(validSteps);

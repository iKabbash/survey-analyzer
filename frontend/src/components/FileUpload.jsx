import React, { useState } from 'react';
import axios from 'axios';

// Code reference: https://www.filestack.com/fileschool/react/react-file-upload/

const FileUpload = () => {
    const [file, setFile] = useState();
    const [uploadedFile, setUploadedFile] = useState();
    const [error, setError] = useState();
    const [response, setResponse] = useState();
    const [isParagraphVisible, setIsParagraphVisible] = useState(false);

    function handleChange(event) {
        setFile(event.target.files[0]);
    }

    function handleSubmit(event) {
        event.preventDefault();
        const url = 'http://localhost:5000/analyze';
        const formData = new FormData();
        formData.append('file', file);
        formData.append('fileName', file.name);
        const config = {
            headers: {
                'content-type': 'multipart/form-data',
            },
        };
        axios.post(url, formData, config)
            .then((response) => {
                console.log(response.data);
                setResponse(response.data);
                setUploadedFile(response.data.file);
                setIsParagraphVisible(true);
            })
            .catch((error) => {
                console.error("Error uploading file: ", error);
                setError(error);
            });
    }

    return (
        <div className="mt-10">
            <form onSubmit={handleSubmit}>
                <h1 className='md:text-2xl sm:text-xl text-xl font-bold py-2 text-text2'>Upload survey response document</h1>
                <div className='mt-3'>
                    <input onChange={handleChange} type="file" className="text-sm text-stone-500 file:mr-5 file:py-1 file:px-3 file:border-[1px]
                    file:font-medium file:bg-stone-50 file:text-stone-700 hover:file:cursor-pointe
                    hover:file:bg-blue-50 file:rounded-sm hover:file:text-text2" id="file_input" />
                    <button type="submit" className='text-white bg-text2 hover:bg-text1 font-medium
                    rounded-md text-sm px-5 py-1.5 me-2 mb-2 dark:bg-text2 dark:hover:bg-text1'>Analyze</button>

                    <textarea readOnly id="message" rows="4" className="block p-2.5 w-full h-40 mt-2 text-sm text-gray-900 bg-gray-50
                    rounded-md border border-gray-300 focus:ring-blue-500 focus:border-blue-500 dark:border-gray-600 dark:placeholder-gray-400
                    dark:focus:ring-blue-500 dark:focus:border-blue-500" placeholder="JSON output goes here..." value={JSON.stringify(response)}></textarea>
                </div>
            </form>
            {uploadedFile && <img src={uploadedFile} alt="Uploaded content" />}
            {error && <p>Error uploading file: {error.message}</p>}
            { isParagraphVisible && (<p className='mt-2'>Feedback rate: {JSON.stringify(response.Sentiment.Result)}</p>) }
        </div>
    );
};

export default FileUpload;

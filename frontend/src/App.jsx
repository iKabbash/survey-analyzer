import Navbar from "./components/Navbar";
import FileUpload from './components/FileUpload';

function App() {

  return (
    <>
      <Navbar />
      <div className="max-w-screen-lg mt-[-150px] w-full h-screen mx-auto text-left flex flex-col justify-center sm:px-10">
        <h1 className="md:text-6xl sm:text-5xl text-3xl font-bold md:py-6 text-text1">
          Survey Analyzer
        </h1>
        <div className="flex">
          <p className="md:text-3xl sm:text-2xl text-2xl font-bold py-2 text-text2">
            Created using Azure's Document Intelligence and Language cognitive services
          </p>
        </div>
        <FileUpload />
      </div>
    </>
  )
}

export default App
import React from 'react'
import LoginCard from '../components/LoginCard'

const Login = () => {
    return (
        <div className="min-h-screen md:bg-clg-bg md:bg-cover w-full flex items-center justify-center bg-gradient-to-br from-[#e0f1ff] to-[#f2f6ff] px-4">
            <div className="absolute inset-0 bg-black opacity-60 z-0 hidden md:block"></div>

            <div className='flex flex-col w-full md:justify-around md:flex-row items-center justify-center z-10 '>
                <div className='md:text-white text-gray-700 text-center md:w-[30vw] w-[70vw] space-y-4 mt-10 md:mt-0'>
                    <h1 className='text-red-500 flex justify-center text-5xl'> <span>
                        <img src="\logo2.png" alt="Logo" className='sm:w-50 sm:h-30 w-10 h-10'/>
                    </span>Techno Enginnering College Banipur</h1>
                    <h3 className='font-bold text-[1.2rem]'>Approved by AICTE, Affliated to MAKAUT, WB </h3>
                    <p>To emerge as a centre of excellence by producing
                        technically sound and ethically strong engineers who
                        will be adaptive, accommodative, innovative and
                        cooperative by nature coupled with leadership quality
                        in order to serve the industry as an effective resource
                        encouraging them to go for higher study and also
                        motivating them to become successful entrepreneurs
                        for generating employment to serve the society and
                        the nation in ultimate.</p>
                </div>
                <div className='m-6'>
                    <LoginCard />
                </div>
            </div>
        </div>
    )
}

export default Login
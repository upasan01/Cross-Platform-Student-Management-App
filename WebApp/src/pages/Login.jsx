import React from 'react'
import LoginCard from '../components/LoginCard'

const Login = () => {
    return (
        <div className="min-h-screen md:bg-clg-bg md:bg-cover w-full flex items-center justify-center bg-gradient-to-br from-[#e0f1ff] to-[#f2f6ff] px-4">
            <div className="absolute inset-0 bg-black opacity-60 z-0 hidden md:block"></div>

            <div className='flex flex-col w-full md:justify-around md:flex-row items-center justify-center z-10 '>
                <div className='md:text-white text-gray-700 text-center md:w-[55vw]  space-y-4 mt-10 md:mt-0'>
                    <div className='flex justify-center items-center space-x-4 font-bold sm:flex-row flex-col'>
                        <div>
                            <img src="\logo2.png" alt="Logo" className='sm:w-30 sm:h-30 w-20 h-20' />
                        </div>
                        <div className='sm:text-[40px]  text-3xl text-red-600'>
                            Techno Engineering College Banipur
                        </div>
                    </div>
                    <h3 className='font-bold sm:text-[1.2rem] '>Approved by AICTE, Affliated to MAKAUT, WB </h3>
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
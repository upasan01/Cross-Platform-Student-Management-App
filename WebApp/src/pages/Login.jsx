import React from 'react'
import LoginCard from '../components/LoginCard'

const Login = () => {
    return (
        <div className="min-h-screen md:bg-clg-bg md:bg-cover w-full flex items-center justify-center bg-gradient-to-br from-[#e0f1ff] to-[#f2f6ff] px-4">
            <div className="absolute inset-0 bg-black opacity-60 z-0 hidden md:block"></div>

            <div className='flex flex-col w-full md:justify-around md:flex-row items-center justify-center z-10 '>
                <div className='md:text-white text-gray-700 text-center md:w-[30vw] w-[70vw] space-y-4 mt-10 md:mt-0'>
                    <h1>Lorem ipsum dolor sit amet consectetur adipisicing elit</h1>
                    <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Consequuntur sunt accusantium possimus nemo culpa, numquam dicta quod ducimus officiis soluta magni blanditiis laborum quasi distinctio unde enim. Mollitia nisi nesciunt voluptatem cum odit aliquam ipsam.</p>
                </div>
                <div className='m-6'>
                    <LoginCard />
                </div>
            </div>
        </div>
    )
}

export default Login
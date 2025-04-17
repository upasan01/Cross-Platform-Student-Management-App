import React from 'react'
import { NavLink } from 'react-router-dom'
import LoginCard from '../components/LoginCard'

const Login = () => {
    return (
        <div className='bg-clg-bg bg-cover bg-center h-screen flex items-center justify-center overflow-hidden'>
            <div className="absolute inset-0 bg-black opacity-60 z-0"></div>
            <div className='flex items-center justify-center z-10'>
                <div className='text-white text-center w-[30vw]'>
                    <h1>Lorem ipsum dolor sit amet consectetur adipisicing elit</h1>
                    <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Consequuntur sunt accusantium possimus nemo culpa, numquam dicta quod ducimus officiis soluta magni blanditiis laborum quasi distinctio unde enim. Mollitia nisi nesciunt voluptatem cum odit aliquam ipsam.</p>

                    </div>
                <div className=' ml-96'>

                    <LoginCard />
                </div>
            </div>
        </div>
    )
}

export default Login

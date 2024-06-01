import React from "react";
import Logo from "../assets/Logo400.svg";

const Navbar = () => {

  return (
    <div className="flex justify-between items-center h-16 max-w mx-auto px-4 text-gray-100 sticky top-0 z-50 bg-background opacity-95">
      <img src={Logo} alt={"Logo400"} className="ml-10 md:ml-20 h-12 opacity-100" />
    </div>
  );
};

export default Navbar;
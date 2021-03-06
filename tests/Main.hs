
module Main where

import Test.Tasty
import Test.Tasty.Golden
import System.Process
import System.FilePath
import Data.List (intercalate)

main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests" [moduleTests, symbolTests]

moduleTests :: TestTree
moduleTests = testGroup "Module Tests"
   [ hsImportTest "ModuleTest0" "Foo.Bar" "" 
   , hsImportTest "ModuleTest1" "Foo.Bar" ""
   , hsImportTest "ModuleTest2" "Foo.Bar.Blub" ""
   , hsImportTest "ModuleTest3" "Control.Monad" ""
   , hsImportTest "ModuleTest4" "Ugah.Argh2" ""
   , hsImportTest "ModuleTest5" "Control.Monad" ""
   , hsImportTest "ModuleTest6" "Control.Monad" ""
   , hsImportTest "ModuleTest7" "Control.Monad" ""
   , hsImportTest "ModuleTest8" "Control.Monad" ""
   , hsImportTest "ModuleTest9" "Control.Monad" ""
   ]


symbolTests :: TestTree
symbolTests = testGroup "Symbol Tests"
   [ hsImportTest "SymbolTest0" "Foo.Bar" "foo"
   , hsImportTest "SymbolTest1" "Foo.Bar" "foo"
   , hsImportTest "SymbolTest2" "Foo.Bar.Blub" "foo"
   , hsImportTest "SymbolTest3" "Control.Monad" "when"
   , hsImportTest "SymbolTest4" "Ugah.Argh2" "argh"
   , hsImportTest "SymbolTest5" "Control.Monad" "when"
   , hsImportTest "SymbolTest6" "Control.Monad" "unless"
   , hsImportTest "SymbolTest7" "Control.Monad" "unless"
   , hsImportTest "SymbolTest8" "Control.Monad" "unless"
   , hsImportTest "SymbolTest9" "Control.Monad" "unless"
   , hsImportTest "SymbolTest10" "Control.Applicative" "<$>"
   , hsImportTest "SymbolTest11" "Control.Applicative" "<$>"
   , hsImportTest "SymbolTest12" "Control.Applicative" "<$>"
   , hsImportTest "SymbolTest13" "Control.Applicative" "<*"
   , hsImportTest "SymbolTest14" "Control.Applicative" "<*"
   , hsImportTest "SymbolTest15" "Control.Applicative" "*>"
   ]


hsImportTest :: String -> String -> String -> TestTree
hsImportTest testName moduleName symbolName =
   goldenVsFile testName goldenFile outputFile command
   where
      command = do
        handle <- runCommand $ "hsimport " ++ params
        waitForProcess handle
        return ()

      params      = intercalate " " [moduleParam, symbolParam, outputParam, inputFile]
      moduleParam = "-m '" ++ moduleName ++ "'"
      symbolParam = if null symbolName then "" else "-s '" ++ symbolName ++ "'"
      outputParam = "-o '" ++ outputFile ++ "'"

      goldenFile = "tests" </> "goldenFiles" </> testName <.> "hs"
      outputFile = "tests" </> "outputFiles" </> testName <.> "hs"
      inputFile  = "tests" </> "inputFiles"  </> testName <.> "hs"

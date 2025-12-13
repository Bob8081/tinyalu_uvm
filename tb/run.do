# Compile
vlog -f tb.f

# Run simulation with coverage
vsim -coverage work.tinyalu_top

set NoQuitOnFinish 1
onbreak {resume}

# Run until completion
run -all

coverage report -details

# Save coverage database
# coverage save uvm.ucdb

# Generate HTML coverage report
# vcover report uvm.ucdb -html -output cov_html

# Exit Questa
quit -f
package version

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestHoldPackageTestify(t *testing.T) {
	assert.Equal(t, "0.1.0", Version)
}
